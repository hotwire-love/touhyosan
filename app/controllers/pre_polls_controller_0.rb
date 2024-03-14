# includeしているコードは以下の記事を参照して作成しました。
#
# [\[Rails\]turboのカスタムアクションを使ってみる](https://zenn.dev/redheadchloe/articles/d567e7795f0acf)
include TurboStreams::RedirectHelper

class PrePollsController < ApplicationController
  before_action :set_pre_poll, only: %i[ show edit update propose append ]

  def show
    render :all, locals: { pre_poll: @pre_poll }
  end

  # PATCH/PUT /pre_polls/1 or /pre_polls/1.json
  def update
    if @pre_poll.update(pre_poll_params)
      btn_name = params["btn"]
      if btn_name == "生成"
        error_count = 0
        @poll = create_poll_with_content(@pre_poll, @pre_poll.content)
        if !@poll.save
          error_count += 1
        end

        if error_count.zero?
          message = "Pollを生成しました"
          respond_to do |format|
            format.html {
              redirect_to poll_path(@poll), notice: message
            }
            format.json { render :show, status: :created, location: @pre_poll }
            format.turbo_stream {
              # flash.now.notice = message
              render turbo_stream: turbo_stream.redirect(poll_path(@poll))
            }
          end
          # format.turbo_stream { render turbo_stream: turbo_stream.redirect(poll_path(@poll)) }
          # redirect_to poll_path(@poll)
          # @pre_poll.broadcast_action_to @pre_poll, action: :redirect, url: poll_path(@poll)
          # pre_pollのsaveに失敗すると、
        else
          redirect_to root_path, status: :unprocessable_entity
          # render :new, status: :unprocessable_entity
        end
      else
        respond_to do |format|
          format.html {
            render :all, notice: message
          }
          format.json { render :show, status: :created, location: @pre_poll }
          format.turbo_stream {
            # render "update.turbo_stream.erb"
            # render turbo_stream: turbo_stream.replace("pre_poll_form", partial: "pre_polls/form", locals: { pre_poll: @pre_poll })
            # Turbo::StreamsChannel.broadcast_replace_to @pre_poll, target: "pre_poll_form", partial: "pre_polls/form", locals: { pre_poll: @pre_poll })
            Turbo::StreamsChannel.broadcast_update_to(@pre_poll, target: "pre_poll_form", partial: "pre_polls/formx", locals: { pre_poll: @pre_poll })
          }
        end
      end
    else
      #TODO: debugテンプレートを削除する
      # raise
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.json { render json: @pre_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def append
    content = @pre_poll.content + "\n" + params[:content]
    @pre_poll.update(content: content)
    @pre_poll.broadcast_replace_to "pre_poll", partial: "pre_polls/all", locals: { pre_poll: @pre_poll }
  end

  def propose
    # accept_pre_poll_proposals
    content = @pre_poll.content
    if !(content.nil? || content.empty? || content.strip.size.zero?)
      content += ("\n" + lines.join("\n"))
    end
    respond_to do |format|
      if @pre_poll.update(content: content)
        @pre_poll.broadcast_update_to "pre_poll", partial: "pre_polls/all", locals: { pre_poll: @pre_poll }
=begin
        format.html { render :all }
        # format.turbo_stream { render :form }
        format.turbo_stream { render turbo_stream: turbo_stream.redirect(root_url) }
        format.json { render :show, status: :ok, location: @pre_poll }
=end
      else
        format.html { render :all, status: :unprocessable_entity }
        format.turbo_stream { render :all, status: :unprocessable_entity }
        format.json { render :show, status: :unprocessable_entity, location: @pre_poll }
      end
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
