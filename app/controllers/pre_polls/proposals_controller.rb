module PrePolls
  class ProposalsController < ApplicationController
    #    before_action :set_proposal, only: %i[ edit update destroy ]
    before_action :set_pre_poll, only: %i[ new create edit update ]
    before_action :set_proposal, only: %i[ edit update ]

    # GET /proposals/new
    def new
      @proposal = @pre_poll.proposals.new
    end

    # POST /proposals or /proposals.json
    def create
      @proposal = @pre_poll.proposals.new(proposal_params)
      proposal_params[:content].split("\n").each do |title|
        next if title.blank?
        @proposal.choiceitems.build(title: title, accepted: false)
      end
      if @proposal.save
        @proposal.broadcast_replace_to @pre_poll, target: "pre_poll_result", partial: "pre_polls/result", locals: { pre_poll: @pre_poll }
        message = "提案を作成しました"
        respond_to do |format|
          format.html { redirect_to pre_poll_path(@pre_poll), notice: message }
          format.turbo_stream {
            flash.now.notice = message
            render "result", pre_poll: @pre_poll
          }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    # GET /proposals/1/edit
    def edit
      # @proposal = @pre_poll.proposals.find(params[:id])
    end

    # PATCH/PUT /proposals/1 or /proposals/1.json
    def update
      # @proposal = @pre_poll.proposals.find(params[:id])

      if @proposal.update(proposal_params)
        @proposal.broadcast_replace_to @pre_poll, target: "pre_poll_result", partial: "pre_polls/result", locals: { pre_poll: @pre_poll }

        message = "提案を更新しました"
        respond_to do |format|
          format.html { redirect_to poll_path(@pre_poll), notice: message }
          format.turbo_stream {
            flash.now.notice = message
            render "result"
          }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.

    def set_pre_poll
      @pre_poll = PrePoll.find(params[:pre_poll_id])
    end

    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proposal_params
      params.require(:proposal).permit(:user_name, :content,
                                       choiceitem_attributes: %i[id title accepted])
    end
  end
end
