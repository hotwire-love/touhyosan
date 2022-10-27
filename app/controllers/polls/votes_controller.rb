module Polls
  class VotesController < ApplicationController
    before_action :set_poll

    def new
      @vote = @poll.votes.new
      @poll.choices.each do |choice|
        @vote.vote_details.build(choice: choice)
      end
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
      params.require(:vote).permit(:user_name,
                                   :comment,
                                   vote_details_attributes: %i[choice_id status])
    end
  end
end
