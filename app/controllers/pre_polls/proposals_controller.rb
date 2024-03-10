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
      if params[:proposal][:content]
        params[:proposal][:content].split("\n").each do |title|
          next if title.blank?
          @proposal.choiceitems.build(title: title, accepted: false)
        end
      end
      if @proposal.save
        @proposal.broadcast_replace_to @pre_poll, target: "pre_poll_table", partial: "pre_polls/table", locals: { pre_poll: @pre_poll }
        message = "提案を作成しました"
        flash.now.notice = message
        redirect_to pre_poll_path(@pre_poll)
      else
        render :new, status: :unprocessable_entity
      end
    end

    # GET /proposals/1/edit
    def edit
      @proposal.content = ""
      # @proposal = @pre_poll.proposals.find(params[:id])
    end

    # PATCH/PUT /proposals/1 or /proposals/1.json
    def update
      # @proposal = @pre_poll.proposals.find(params[:id])
      content = params[:proposal][:content]
      if content
        content.split("\n").each do |title|
          next if title.blank?
          @proposal.choiceitems.build(title: title, accepted: false)
        end
        if @proposal.update(proposal_params)
          @proposal.broadcast_replace_to @pre_poll, target: "pre_poll_table", partial: "pre_polls/table", locals: { pre_poll: @pre_poll }

          message = "提案を更新しました"
          flash.now.notice = message
          redirect_to pre_poll_path(@pre_poll)
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
