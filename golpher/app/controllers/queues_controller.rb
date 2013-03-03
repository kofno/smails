class QueuesController < ApplicationController
  rescue_from QueueNotFoundError, with: :render_404

  respond_to :html, :json

  def index
    @queues = queues
  end

  def show
    @queue = queues.find_by_name params[:id]
  end

  private

  def queues
    Queues.new
  end
end
