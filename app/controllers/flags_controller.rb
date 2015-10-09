class FlagsController < ApplicationController
  before_action :set_flag, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  protect_from_forgery :except => [:userscript_new]

  def userscript_new
    @flag = Flag.new

    origin = request.headers['origin'].scan(/https?:\/\/(.*)$/)[0][0]
    site = Site.find_by_site_domain(origin)

    if site.nil?
      render :text => "Site not recognized"
      return
    end

    @flag.site = site

    if params[:post_id].present? and params[:comment_ids].present?
      render :text => "Can't flag a post and a comment at the same time"
      return
    end
    if params[:post_id].nil? and params[:comment_ids].nil?
      render :text => "Don't know what to flag"
      return
    end

    if params[:post_id].present?
      @flag.post_id = params[:post_id]
    else #we're dealing with comments
      @flag.comment_ids = params[:comment_ids]
    end

    if params[:flag_type].nil?
      render :text => "No flag type, don't know how to flag"
      return
    end

    type = FlagType.find_by_name(params[:flag_type])

    if type.nil?
      render :text => "Unrecognized flag type"
      return
    end

    @flag.flag_type = type

    @flag.flag_queue = current_user.flag_queues.first

    if @flag.save
      render :text => "OK"
    else
      render :text => "Something went wrong"
    end
  end

  def update_frequency
    queue = current_user.flag_queues.first

    queue.frequency = params[:flag_queue][:frequency]
    queue.save!

    redirect_to '/'
  end

  # GET /flags
  # GET /flags.json
  def index
    @queued_flags = current_user.flag_queues.first.flags.where(:completed => false).order('created_at ASC')
    @errored_flags = current_user.flag_queues.first.flags.where.not(:failure_reason => nil)
    @completed_flags = current_user.flag_queues.first.flags.where(:completed => true, :failure_reason => nil).order('attempted_at DESC')
  end

  # GET /flags/1
  # GET /flags/1.json
  def show
  end

  # GET /flags/new
  def new
    @flag = Flag.new
  end

  # GET /flags/1/edit
  def edit
  end

  # POST /flags
  # POST /flags.json
  def create
    @flag = Flag.new(flag_params)
    @flag.flag_queue = current_user.flag_queues.first

    if @flag.comment_ids.present? and @flag.post_id.present?
      render :text => "You can't flag a post and comments at the same time." and return
    end

    @flag.post_type = "comments" if @flag.comment_ids.present?

    if @flag.save
      respond_to do |format|
        format.html { redirect_to flags_path, notice: 'Flag was successfully created.' }
        format.json { render :show, status: :created, location: @flag }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flags/1
  # PATCH/PUT /flags/1.json
  def update
    respond_to do |format|
      if @flag.update(flag_params)
        format.html { redirect_to @flag, notice: 'Flag was successfully updated.' }
        format.json { render :show, status: :ok, location: @flag }
      else
        format.html { render :edit }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flags/1
  # DELETE /flags/1.json
  def destroy
    @flag.destroy
    respond_to do |format|
      format.html { redirect_to flags_url, notice: 'Flag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flag
      @flag = Flag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flag_params
      params.require(:flag).permit(:post_id, :flag_type_id, :site_id, :comment_ids)
    end
end
