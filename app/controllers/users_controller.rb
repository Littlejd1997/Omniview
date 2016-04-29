class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:finishFacebook]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end
  def fbAuth
    redirect_to $fboauth.url_for_oauth_code(permissions: "publish_actions")

  end
  def oauth
    user = current_user
    oauth = $fboauth.get_access_token_info(params[:code])
    user.fbtoken = oauth["access_token"]
    user.fbexpires = Time.now+oauth["expires"].to_i
    user.save
    redirect_to action: :setupFacebook
  end
  def setupFacebook
    @user_graph = Koala::Facebook::API.new(current_user.fbtoken)
  end
  def finishFacebook
    current_user.pageid = params["page"]
    current_user.defaultOrientation = params["orientation"]
    current_user.save
    flash[:notice] = "Facebook setup complete!"

    redirect_to current_user
  end

  def fail
    render text: "Sorry, but the following error has occured: #{params[:message]}. Please try again or contact
administrator."
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_twitterhandle(params[:twitterhandle])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:twitterhandle, :email, :password, :password_confirmation)
    end
end
