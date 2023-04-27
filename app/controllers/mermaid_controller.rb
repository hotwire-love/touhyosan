class MermaidController < ApplicationController
  def show
	render file: "#{Rails.root}/public/mermaid_erd.html", layout: false
  end
end
