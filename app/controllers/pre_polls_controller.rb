class PrePollsController < ApplicationController
  before_action :set_pre_poll, only: %i[ show edit update accept ]

  # GET /pre_polls/1 or /pre_polls/1.json
  def show
    #
  end

  def edit
    render :edit, locals: { pre_poll: @pre_poll, editor_id: @pre_poll.editor_id }
  end

  # PATCH/PUT /pre_polls/1 or /pre_polls/1.json
  def update
    if @pre_poll.update(pre_poll_params)
      btn_name = @params[:btn]
      case btn_name
      when "Create" | "CreateAll"
        @poll = create_poll(@pre_poll, pre_poll_params[:content])
        if btn_name == "CreateAll"
          @pre_poll.proposals.map { |proposal|
            create_votes(@poll, proposal)
          }
        end
        if @poll.save
          broadcast_replace_to "proposer", target: "redirect_event_frame", partial: "redirect", locals: {poll: @poll}

          respond_to do |format|
            format.html { 
              redirect_to poll_path(@poll), notice: "Poll was successfully updated." 
            }
            format.json { render :show, status: :ok, location: @poll }
          end
        else
          redirect_to root_path, status: :unprocessable_entity
        end
      end
    else
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
    }.flatten.select{ |line| !(line.nil? || line.empty?) }
    content = @pre_poll.content
    if !(content.nil? || content.empty? || content.strip.size.zero? )
      content += ("\n" + lines.join("\n"))
    else
      content = lines.join("\n")
    end
    respond_to do |format|
      if @pre_poll.update(content: content)
        format.html { render :edit }
        format.turbo_stream { render :form_tf }
        format.json { render :show, status: :ok, location: @pre_poll }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit , status: :unprocessable_entity }
        format.json { render :show, status: :unprocessable_entity, location: @pre_poll }
      end
    end
  end

  private

  def create_poll(pre_poll, content)
    poll = Poll.create(title: pre_poll.title, choices_text: content)
    #TODO: polls_controller#newの処理内容を切り出して共通化できないか
    vote = poll.votes.new
    poll.choices.each_with_index do |choice, index|
      vote.vote_details.build(choice: choice, position: index)
    end
    poll
  end

  def create_votes(poll, proposal)
    vote = poll.votes.new
    vote.user_name = proposal.user_name
    poll.choices.each_with_index do |choice, index|
      vote.vote_details.build(choice: choice, position: index)
    end
end

  def set_pre_poll
    @pre_poll = PrePoll.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pre_poll_params
    params.require(:pre_poll).permit(:content, :btn)
  end
end
