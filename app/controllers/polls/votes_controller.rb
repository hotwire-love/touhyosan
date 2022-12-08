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
        respond_to do |format|
          format.html { redirect_to poll_path(@poll), notice: '投票を作成しました' }
          format.turbo_stream
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
        redirect_to poll_path(@poll), notice: '投票を更新しました'
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
                                   vote_details_attributes: %i[id choice_id status])
    end
  end
end
