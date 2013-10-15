class FollowingsController < ApplicationController
  before_action :set_following, only: [:show, :edit, :update, :destroy]


  def create
    @following = current_user.followings.build(following_params)

    respond_to do |format|
      if @following.save
        format.html { redirect_to :back, notice: "You are now following #{ @following.followee.firstname } " }
        format.json { render action: 'show', status: :created, location: @following }
      else
        format.html { redirect_to current_user, notice: "An error occured while following #{ @following.followee } " }
        format.json { render json: @following.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @following.destroy
    respond_to do |format|
      format.html { redirect_to  :back, notice: "You are not following #{ @following.followee.firstname } now" }
      format.json { head :no_content }
    end
  end

  protected

    def set_following
      @following = current_user.followings.find_by(followee_id: params[:followee_id])
    end

    def following_params
      params.permit(:followee_id)
    end
end
