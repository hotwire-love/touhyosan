module Polls
  class ChoicesController < ApplicationController
    before_action :set_poll

    def index
      @choice = @poll.choices.build
    end

    def create
      @choice = @poll.choices.build(choice_params)
      if @choice.save
        # redirect_to poll_choices_path(@poll)
      else
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
    end

    private

    def set_poll
      @poll = Poll.find(params[:poll_id])
    end

    def choice_params
      params.require(:choice).permit(:title)
    end
  end
end
