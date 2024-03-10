class PrePollsController < ApplicationController
  before_action :set_pre_poll, only: %i[ show edit update accept redirectx ]

  # GET /pre_polls/1 or /pre_polls/1.json
  def show
    render :all, locals: { pre_poll: @pre_poll, editor_id: @pre_poll.editor_id }
  end

  def edit
    render :all, locals: { pre_poll: @pre_poll, editor_id: @pre_poll.editor_id }
  end

  # PATCH/PUT /pre_polls/1 or /pre_polls/1.json
  def update
    if @pre_poll.update(pre_poll_params)
      btn_name = params["btn"]
      if btn_name == "生成" || btn_name == "生成＋投票"
        error_count = 0
        @poll = create_poll_with_content(@pre_poll, @pre_poll.content)
        if @poll.save
          # @poll = Poll.create(title: @pre_poll.title, content: @pre_poll.content)
          if btn_name == "生成＋投票"
            @pre_poll.proposals.map { |proposal|
              error_count += 1 unless create_and_save_votes(@poll, proposal.user_name)
            }
          end
        else
          error_count += 1
        end

        if error_count.zero?
          message = "Poll was successfully updated."
          @pre_poll.broadcast_replace_to "proposer", target: "redirect_event_frame", partial: "pre_polls/redirect", locals: { poll: @poll }
          flash.now.notice = message
          redirect_to poll_path(@poll)
          # pre_pollのsaveに失敗すると、
        else
          redirect_to root_path, status: :unprocessable_entity
          # render :new, status: :unprocessable_entity
        end

        #TODO: debugテンプレートを削除する
      end
    else
      # raise
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pre_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    # accept_pre_poll_proposals
    lines = @pre_poll.proposals.map { |proposal|
      array = []
      proposal.choiceitems.each do |choiceitem|
        if !choiceitem.accepted
          choiceitem.update(accepted: true)
          title = choiceitem.title
          if !(title.nil? || title.empty?)
            title = title.strip
            array << title if title.size.positive?
          end
        end
      end
      array
    }.flatten.select { |line| !(line.nil? || line.empty?) }
    content = @pre_poll.content
    if !(content.nil? || content.empty? || content.strip.size.zero?)
      content += ("\n" + lines.join("\n"))
    else
      content = lines.join("\n")
    end
    respond_to do |format|
      if @pre_poll.update(content: content)
        format.html { render :all }
        format.turbo_stream { render :form }
        format.json { render :show, status: :ok, location: @pre_poll }
      else
        format.html { render :all, status: :unprocessable_entity }
        format.turbo_stream { render :all, status: :unprocessable_entity }
        format.json { render :show, status: :unprocessable_entity, location: @pre_poll }
      end
    end
  end

  def redirectx
    respond_to do |format|
      format.html { render "pre_polls/_redirectx", locals: { pre_poll: @pre_poll } }
      format.turbo_stream { render "pre_polls/redirect", locals: { pre_poll: @pre_poll } }
    end
  end

  private

  # def create_poll(pre_poll, content)
  def create_poll_with_content(pre_poll, content)
    poll = Poll.create(title: pre_poll.title, choices_text: content)
    #TODO: polls_controller#newの処理内容を切り出して共通化できないか
  end

  def create_and_save_votes(poll, user_name)
    ret = true

    vote = poll.votes.new
    vote.user_name = user_name
    if vote.save
      poll.choices.each_with_index do |choice, index|
        vote.vote_details.build(choice: choice, position: index)
        ret = false unless vote.save
      end
    else
      ret = false
    end

    ret
  end

  def set_pre_poll
    @pre_poll = PrePoll.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pre_poll_params
    params.require(:pre_poll).permit(:content, :btn)
  end
end
