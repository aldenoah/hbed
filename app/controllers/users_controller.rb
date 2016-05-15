class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update] # probably want to keep using this
  before_action :authenticate_user!
  before_filter :admin_signed_in?, only: [:index]
 
  # GET /users
  # GET /users.json
  def index
    @users = User.all.order('created_at DESC')
  end
 
  # # GET /users/1
  # # GET /users/1.json
  def show
 
  end
 
  # GET /users/1/edit
  def edit
    if current_user.role == "Admin"
    
    elsif current_user.role == "Member"
      if current_user.id != @user.id
        redirect_to root_url, notice: "Sorry! But the profile that you're trying to access belongs to someone else." 
      end
    else
      redirect_to root_url, notice: "Sorry! But the page that you're trying to access are for members only." 
    end 
  end
 
  # # PATCH/PUT /users/1
  # # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:role, :first_name, :last_name, :email, :phone, :currency)
    end
 
end