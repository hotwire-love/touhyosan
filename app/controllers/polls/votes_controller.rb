module Polls
  class VotesController < ApplicationController
    before_action :set_poll

    def new
      @vote = @poll.votes.new
    end

    def create
      @vote = @poll.votes.new(vote_params)
      if @vote.save
        redirect_to poll_path(@poll), notice: '投票を作成しました'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_poll
      @poll = Poll.find(params[:poll_id])
    end

    def vote_params
      params.require(:vote).permit(:user_name, :comment)
    end
  end
end
