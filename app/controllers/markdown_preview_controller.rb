class MarkdownPreviewController < ApplicationController
  include MarkdownHelper

  def create
    @preview_text = markdown(params[:text])
    respond_to do |format|
      format.turbo_stream
    end
  end
end
