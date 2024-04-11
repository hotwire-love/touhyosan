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
        Turbo::StreamsChannel.broadcast_append_to @poll, target: "choices", partial: 'polls/choices/choice', locals: { choice: @choice }
      else
        render :index, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @choice.update(choice_params)
        Turbo::StreamsChannel.broadcast_replace_to @poll, target: @choice, partial: 'polls/choices/choice', locals: { choice: @choice }
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @choice.destroy
      Turbo::StreamsChannel.broadcast_remove_to @poll, target: @choice
      # NOTE: ごくまれに0バイトのHTMLが返されることがあるので、それを防ぐために destroy.turbo_stream.erb を返す
    end

    private

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
