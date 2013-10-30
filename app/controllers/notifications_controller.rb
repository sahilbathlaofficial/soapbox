class NotificationsController < ApplicationController
  def index
    @notifications = PublicActivity::Activity.where('owner_id = ?', current_user.id).order('id desc')
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def get_new_notifications
    @notifications = PublicActivity::Activity.where('owner_id = ? and seen = false', current_user.id).order('id desc')
      respond_to do |format|
        format.html { redirect_to_back_or_default_url }
        format.js { render json: @notifications }
      end
  end
end
