class PrePollsController < ApplicationController
  before_action :set_pre_poll, only: %i[ show update append ]

  def show
    render template: "pre_polls/show", locals: { append_url: append_pre_poll_url(@pre_poll) }
  end

  # PATCH/PUT /pre_polls/1 or /pre_polls/1.json
  def update
    if @pre_poll.update(pre_poll_params)
      btn_name = params["btn"]
      if btn_name =~ /^生成/
        produce_poll_and_redirect
      else
        Turbo::StreamsChannel.broadcast_update_to(@pre_poll, target: @pre_poll, partial: "pre_polls/form", locals: { pre_poll: @pre_poll })
        respond_to do |format|
          format.html {
            render template: "pre_polls/empty", status: :ok
          }
          format.turbo_stream {
            render template: "pre_polls/empty", status: :ok
          }
        end
      end
    else
      #TODO: debugテンプレートを削除する
      # raise
      respond_to do |format|
        format.html { render template: "pre_polls/show", status: :unprocessable_entity }
        format.turbo_stream { render template: "pre_polls/show", status: :unprocessable_entity }
      end
    end
  end

  def append
    content = make_valid_str(@pre_poll.content, params[:content_add])
    @pre_poll.attributes = { content: content }
    if @pre_poll.save
      @append_url = append_pre_poll_path(@pre_poll)
      Turbo::StreamsChannel.broadcast_update_to(@pre_poll, target: @pre_poll, partial: "pre_polls/form", locals: { pre_poll: @pre_poll })

      respond_to do |format|
        format.html {
          render template: "pre_polls/empty", status: :ok
        }
        format.turbo_stream {
          # 
        }
      end
    else
      #TODO: debugテンプレートを削除する
      # raise
      respond_to do |format|
        format.html { render template: "pre_polls/show", status: :unprocessable_entity }
        format.turbo_stream { render template :"pre_polls/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def check_str(str)
    valid = true
    valid = false if (str.nil? || str.empty?)
    [str, valid]
  end

  def make_valid_str(str1, str2)
    content = nil
    content1, content1_valid = check_str(str1)
    content2, content2_valid = check_str(str2)
    if content1_valid
      if content2_valid
        content = content1 + "\n" + content2
      else
        content = content1
      end
    else
      if content2_valid
        content = content2
      else
        content = "no"
      end
    end
    content
  end

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
          Turbo::StreamsChannel.broadcast_render_to(@pre_poll, template: "pre_polls/redirect", locals: { url: url })
        }
        format.turbo_stream {
          Turbo::StreamsChannel.broadcast_render_to(@pre_poll, partial: "pre_polls/redirect", locals: { url: url })
          render :empty, status: :ok
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
    params.require(:pre_poll).permit(:content, :btn, :content_add, :id)
  end
end
