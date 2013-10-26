class FollowingsController < ApplicationController
  before_action :set_following, only: [:show, :edit, :update, :destroy]


  def create
    @following = current_user.followings.build(following_params)

    respond_to do |format|
      if @following.save
        #FIXME_AB: Should avoid saving html format in db. Just save pointers and generate html when you want to display. We may change the way we display notification in future, so in that case we won't have to bother about what we have in DB
        #[Fixed] Added public activities
        format.html do
          @following.create_activity key: 'following.create', owner: @following.followee
          flash[:notice] = "You are now following #{ @following.followee.firstname } " 
          redirect_to_back_or_default_url 
        end
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
      format.html do
        redirect_to_back_or_default_url
        flash[:notice] = "You are not following #{ @following.followee.firstname } now" 
      end 
      format.json { head :no_content }
    end
  end

  protected

    def set_following
      begin
        @following = current_user.followings.find_by(followee_id: params[:followee_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to_back_or_default_url
      end
    end

    def following_params
      params.permit(:followee_id)
    end
end
