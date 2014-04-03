class UsersController < ApplicationController
  def new
    @titre = "Sign Up"
  end

  def show
    @user = User.find(params[:id])
  end
end
