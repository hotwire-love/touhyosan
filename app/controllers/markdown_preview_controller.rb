class MarkdownPreviewController < ApplicationController
  include MarkdownHelper

  def create
    render plain: markdown(params[:text])
  end
end
