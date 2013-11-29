class NotificationsController < ApplicationController
  def index
    @notifications = PublicActivity::Activity.fetch_notifications(current_user.id)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def get_new_notifications
    @notifications = PublicActivity::Activity.fetch_notifications(current_user.id, false)
    respond_to do |format|
      format.html { redirect_to_back_or_default_url }
      format.js { render json: @notifications }
    end
  end
end
