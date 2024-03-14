class PollsController < ApplicationController
  def show
    @poll = Poll.find(params[:id])
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
    # pollに選択肢を定義しなかった場合、pre_pollを作成し、他の人からの提案を受け付ける
    if @poll.choices_text.strip.size == 0
      #editor_idは他のセッションと区別をつけるために設定する。設定内容は他のセッションと区別がつけられれば何でも良い
      @pre_poll = PrePoll.create(title: @poll.title)
      redirect_to pre_poll_path(@pre_poll)
    else
      if @poll.save
        redirect_to poll_path(@poll)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:title, :choices_text)
  end
end
