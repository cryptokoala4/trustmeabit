class UsersController < ApplicationController
  before_action :set_user

  def identification
    # @user = User.find_by(identification: params[:identification])
    # if @user.nil?
    #   render json: {message: "User not found"}
    # else
    #   render json: @user
    # end

    render json: @user
  end

  private

  def set_user
    @user = User.find_by(identification: params[:identification])
    if @user.nil?
      render json: {message: "User not found"}
    end
  end
end
