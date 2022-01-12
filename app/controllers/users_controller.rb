class UsersController < ApplicationController
  include Authenticate
  before_action :authenticate_admin!#, only: %i[ index show edit update destroy admin ]
  before_action :set_user, only: %i[ show edit update destroy admin ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH /users/1/admin
  def admin
    admin = !@user.admin
    valid = (admin == false && @user.can_revoke_admin(current_user)) || admin == true

    respond_to do |format|
      if valid and @user.update({admin: admin}) #TODO not revoking own / Last admin permissions
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, errors: @user.errors }
        format.js {render 'layouts/toast', locals: { :method => "error", :message => @user.errors.messages.values.flatten, :title => ""}}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    respond_to do |format|
      unless(@user.is_last_admin)
        @user.destroy
        format.html { redirect_to users_url, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      else
        format.js {render 'layouts/toast', locals: { :method => "error", :message => "You cannot delete the last Admin", :title => ""}}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :admin, :avatar)
    end
end
