class PollsController < ApplicationController
  def show
    @poll = Poll.find(params[:id])
  end

  def new
    @poll = Poll.new
  end

  # GET /pre_polls/1/edit
  def edit
  end

  def create
    @poll = Poll.new(poll_params)
    # pollに選択肢を定義しなかった場合、pre_pollを作成し、他の人からの提案を受け付ける
    if @poll.choices_text.strip.size == 0
      #editor_idは他のセッションと区別をつけるために設定する。設定内容は他のセッションと区別がつけられれば何でも良い
      editor_id = "#{@poll.id}-#{Time.now.to_i}-#{self.object_id}"
      set_current_editor(editor_id)
      @pre_poll = PrePoll.create(title: @poll.title, editor_id: editor_id)
      redirect_to pre_poll_path(@pre_poll)
    else
      if @poll.save
        redirect_to poll_path(@poll)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def set_current_editor(editor)
    session[:editor] = editor
  end

  private

  def poll_params
    params.require(:poll).permit(:title, :choices_text)
  end
end
