module NotificationConcern
  
  def notify_tagged_users(tags, post)
    user_ids = tags.split
      for user_id in user_ids
        @user = User.find(user_id)
        if !(@user.nil?)
          SoapBoxMailer.tag_email(@user, post).deliver  
          post.create_activity key: 'post.tagged', owner: @user
        end
      end 
    
  end

end