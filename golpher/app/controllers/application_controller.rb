class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def render_404
    respond_to do |format|
      format.html { render file: 'public/404.html', status: 404 }
    end
  end
end
