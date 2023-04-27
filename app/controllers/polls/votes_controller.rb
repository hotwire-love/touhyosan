module Polls
  class VotesController < ApplicationController
    before_action :set_poll

    def new
      @vote = @poll.votes.new
      @poll.choices.each_with_index do |choice, index|
        @vote.vote_details.build(choice: choice, position: index)
      end
    end

    def create
      @vote = @poll.votes.new(vote_params)
      if @vote.save
        @message = "投票を作成しました"
        @vote.broadcast_replace_to @poll, target: "poll_result", partial: 'polls/result', locals: { poll: @poll }
        respond_to do |format|
          format.html { redirect_to poll_path(@poll), notice: @message }
          format.turbo_stream { render 'result' }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @vote = @poll.votes.find(params[:id])
    end

    def update
      @vote = @poll.votes.find(params[:id])

      if @vote.update(vote_params)
        @message = "投票を更新しました"
        @vote.broadcast_replace_to @poll, target: "poll_result", partial: 'polls/result', locals: { poll: @poll }
        respond_to do |format|
          format.html { redirect_to poll_path(@poll), notice: @message }
          format.turbo_stream { render 'result' }
        end

      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_poll
      @poll = Poll.find(params[:poll_id])
    end

    def vote_params
      params.require(:vote).permit(:user_name,
                                   :comment,
                                   vote_details_attributes: %i[id choice_id status position])
    end
  end
end
