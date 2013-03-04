class QueuesController < ApplicationController
  rescue_from QueueNotFoundError, with: :render_404

  respond_to :html, :json

  def index
    @queues = queues
  end

  def show
    @queue = queue params[:id]
  end

  def clear
    @queue = queue params[:id]
    @queue.clear
    respond_to do |format|
      format.html { redirect_to queue_url(@queue.name) }
    end
  end

  private

  def queues
    Queues.new
  end

  def queue name
    queues.find_by_name name
  end
end
