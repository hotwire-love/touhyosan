class PrePollsController < ApplicationController
  before_action :set_pre_poll, only: %i[ show edit ]

  # GET /pre_polls/1 or /pre_polls/1.json
  def show
    @current_editor = current_editor
    # render :edit
  end

  def edit
    @current_editor = current_editor
  end

  # PATCH/PUT /pre_polls/1 or /pre_polls/1.json
  def update
    respond_to do |format|
      if pre_poll_param[:commit] == "Accept"
        accept
      else
        pre_poll_params
        if @pre_poll.update(pre_poll_params)
          @poll = Poll.create(title: @pre_poll.title, choices_text: pre_poll_params[:content])

          format.html { redirect_to poll_path(@poll), notice: "Poll was successfully updated." }
          format.json { render :show, status: :ok, location: @poll }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @pre_poll.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def accept
    # accept_pre_poll_proposals
    lines = @pre_poll.proposals.map { |proposal|
      array = []
      proposal.choiceitems.each do |choiceitem|
        if !choiceitem.accepted
          choiceitem.update(accepted: true)
          array << choiceitem.title
        end
      end
      array
    }.flatten
    content = pre_poll_params[:content] + "\n" + lines.join("\n")
    @pre_poll.update(content: content)
    # render :edit

    @pre_poll.broadcast_update_to "editor", target: "editor_form", partial: "pre_polls/form", locals: { pre_poll: @pre_poll }
    @pre_poll.broadcast_replace_to "proposer", target: "pre_poll_result", partial: "pre_polls/proposals/result", locals: { pre_poll: @pre_poll }

    "pre_polls/proposals/form", pre_poll: @pre_poll 

  end

  def set_pre_poll
    @pre_poll = PrePoll.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pre_poll_params
    params.require(:pre_poll).permit(:content)
  end
end
