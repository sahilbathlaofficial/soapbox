class NotificationsController < ApplicationController
  def index
    @notifications = PublicActivity::Activity.all
    respond_to do |format|
      format.html { render text: @notifications.first.key }
      format.js {}
    end
  end
end
