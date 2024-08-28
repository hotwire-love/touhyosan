module Polls
  class ChoicesController < ApplicationController
    before_action :set_poll
    before_action :set_choice, only: [:edit, :update, :destroy]

    def index
      @choice = @poll.choices.build
    end

    def create
      @choice = @poll.choices.build(choice_params)
      if @choice.save
        Turbo::StreamsChannel.broadcast_append_to @poll, target: "poll-choices", partial: 'polls/choices/choice', locals: { choice: @choice }

        broadcast_choice_change
      else
        render :index, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @choice.update(choice_params)
        Turbo::StreamsChannel.broadcast_replace_to @poll, target: [@choice, 'poll-choice'], partial: 'polls/choices/choice', locals: { choice: @choice }

        broadcast_choice_change
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @choice.destroy
      # TODO: [@choice, 'poll-choice'] をうまく管理したい
      Turbo::StreamsChannel.broadcast_remove_to @poll, target: [@choice, 'poll-choice']

      broadcast_choice_change

      # NOTE: ごくまれに0バイトのHTMLが返されることがあるので、それを防ぐために destroy.turbo_stream.erb を返す
    end

    private

    def broadcast_choice_change
      Turbo::StreamsChannel.broadcast_replace_to @poll, target: "poll_result", partial: 'polls/result', locals: { poll: @poll }

      @poll.votes.each do |vote|
        Turbo::StreamsChannel.broadcast_replace_to vote, target: 'vote_details', partial: 'polls/votes/vote_details', locals: { poll: @poll, vote: vote }
      end

      new_vote = @poll.votes.new
      @poll.choices.each_with_index do |choice, index|
        new_vote.vote_details.build(choice: choice, position: index)
      end
      Turbo::StreamsChannel.broadcast_replace_to "#{@poll.id}-new-vote", target: 'vote_details', partial: 'polls/votes/vote_details', locals: { poll: @poll, vote: new_vote }
    end

    def set_poll
      @poll = Poll.find(params[:poll_id])
    end

    def set_choice
      @choice = @poll.choices.find(params[:id])
    end

    def choice_params
      params.require(:choice).permit(:title)
    end
  end
end
