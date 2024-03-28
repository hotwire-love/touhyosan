class PrePollsController < ApplicationController
  before_action :set_pre_poll, only: %i[ show edit update propose append ]

  def show
    render :all, locals: { pre_poll: @pre_poll }
  end

  # PATCH/PUT /pre_polls/1 or /pre_polls/1.json
  def update
    if @pre_poll.update(pre_poll_params)
      btn_name = params["btn"]
      if btn_name =~ /^生成/
        produce_poll_and_redirect
      else
        respond_to do |format|
          format.html {
            # render :all, notice: message
            # Turbo::StreamsChannel.broadcast_replace_to(@pre_poll, target: "pre_poll_form", partial: "pre_polls/all", locals: { pre_poll: @pre_poll })
            # Turbo::StreamsChannel.broadcast_replace_to(@pre_poll, target: "pre_poll_form", template: "pre_polls/all", locals: { pre_poll: @pre_poll })
            # Turbo::StreamsChannel.broadcast_update_to(@pre_poll, target: "pre_poll_form", template: "pre_polls/all", locals: { pre_poll: @pre_poll })
            # Turbo::StreamsChannel.broadcast_update_to(@pre_poll, template: "pre_polls/all", locals: { pre_poll: @pre_poll })
            # Turbo::StreamsChannel.broadcast_update_to(@pre_poll, template: "pre_polls/all2", locals: { pre_poll: @pre_poll })
            # render template: "pre_polls/all2", locals: { pre_poll: @pre_poll }
            Turbo::StreamsChannel.broadcast_replace_to(@pre_poll, target: "pre_poll_form", partial: "pre_polls/form", locals: { pre_poll: @pre_poll })
          }
          format.json { render :show, status: :created, location: @pre_poll }
          format.turbo_stream {
            Turbo::StreamsChannel.broadcast_replace_to(@pre_poll, target: "pre_poll_form", partial: "pre_polls/form", locals: { pre_poll: @pre_poll })
          }
        end
      end
    else
      #TODO: debugテンプレートを削除する
      # raise
      respond_to do |format|
        format.html { render :all, status: :unprocessable_entity }
        format.turbo_stream { render :all, status: :unprocessable_entity }
        format.json { render json: @pre_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def produce_poll_and_redirect
    error_count = 0
    @poll = create_poll_with_content(@pre_poll, @pre_poll.content)
    if !@poll.save
      error_count += 1
    end

    if error_count.zero?
      message = "Pollを生成しました"
      url = poll_path(@poll)
      respond_to do |format|
        format.html {
          Turbo::StreamsChannel.broadcast_render_to(@pre_poll, partial: "pre_polls/redirect", locals: { url: url })
        }
        format.json { render :show, status: :created, location: @pre_poll }
        format.turbo_stream {
          Turbo::StreamsChannel.broadcast_render_to(@pre_poll, partial: "pre_polls/redirect", locals: { url: url })
        }
      end
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  # def create_poll(pre_poll, content)
  def create_poll_with_content(pre_poll, content)
    poll = Poll.create(title: pre_poll.title, choices_text: content)
    #TODO: polls_controller#newの処理内容を切り出して共通化できないか
  end

  def set_pre_poll
    @pre_poll = PrePoll.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pre_poll_params
    params.require(:pre_poll).permit(:content, :btn)
  end
end
