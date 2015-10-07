class FlagQueuesController < ApplicationController
  before_action :set_flag_queue, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!

  # GET /flag_queues
  # GET /flag_queues.json
  def index
    @flag_queues = FlagQueue.all
  end

  # GET /flag_queues/1
  # GET /flag_queues/1.json
  def show
  end

  # GET /flag_queues/1/edit
  def edit
  end

  # POST /flag_queues
  # POST /flag_queues.json
  def create
    @flag_queue = FlagQueue.new(flag_queue_params)

    respond_to do |format|
      if @flag_queue.save
        format.html { redirect_to @flag_queue, notice: 'Flag queue was successfully created.' }
        format.json { render :show, status: :created, location: @flag_queue }
      else
        format.html { render :new }
        format.json { render json: @flag_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flag_queues/1
  # PATCH/PUT /flag_queues/1.json
  def update
    respond_to do |format|
      if @flag_queue.update(flag_queue_params)
        format.html { redirect_to @flag_queue, notice: 'Flag queue was successfully updated.' }
        format.json { render :show, status: :ok, location: @flag_queue }
      else
        format.html { render :edit }
        format.json { render json: @flag_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flag_queues/1
  # DELETE /flag_queues/1.json
  def destroy
    @flag_queue.destroy
    respond_to do |format|
      format.html { redirect_to flag_queues_url, notice: 'Flag queue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flag_queue
      @flag_queue = FlagQueue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flag_queue_params
      params.require(:flag_queue).permit(:name)
    end
end
