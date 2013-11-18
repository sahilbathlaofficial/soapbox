module NotificationConcern

  extend ActiveSupport::Concern

  def notify_tagged_users
    post = self.class == Post ? self : self.post
    tags = self.tags
    if !tags.nil?
      user_ids = tags.split
      for user_id in user_ids
        @user = User.find(user_id)
        if !(@user.nil?)
          SoapBoxMailer.tag_email(@user, post, @user.company.name).deliver  
          post.create_activity key: 'post.tagged', owner: @user
        end
      end 
    end
  end

end