class PeriscopesController < ApplicationController
  before_action :set_periscope, only: [:show, :edit, :update, :destroy,:exporttofacebook]

  # GET /periscopes
  # GET /periscopes.json
  def index
    @periscopes = Periscope.all
  end

  # GET /periscopes/1
  # GET /periscopes/1.json
  def show
  end

  # GET /periscopes/1/edit
  def edit
  end
  def exporttofacebook
    UploadToFacebook.perform_later(@periscope)
    flash[:notice] = "Export to Facebook in progress..."
    redirect_to @periscope.user
  end
  # POST /periscopes
  # POST /periscopes.json
  def create
    @periscope = Periscope.new(periscope_params)

    respond_to do |format|
      if @periscope.save
        format.html { redirect_to @periscope, notice: 'Periscope was successfully created.' }
        format.json { render :show, status: :created, location: @periscope }
      else
        format.html { render :new }
        format.json { render json: @periscope.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /periscopes/1
  # PATCH/PUT /periscopes/1.json
  def update
    respond_to do |format|
      if @periscope.update(periscope_params)
        format.html { redirect_to @periscope, notice: 'Periscope was successfully updated.' }
        format.json { render :show, status: :ok, location: @periscope }
      else
        format.html { render :edit }
        format.json { render json: @periscope.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periscopes/1
  # DELETE /periscopes/1.json
  def destroy
    @periscope.destroy
    respond_to do |format|
      format.html { redirect_to periscopes_url, notice: 'Periscope was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_periscope
      @periscope = Periscope.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def periscope_params
      params.require(:periscope).permit(:twitterhandle, :broadcast_id)
    end
end
