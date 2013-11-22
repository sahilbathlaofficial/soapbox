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
          post.create_activity key: 'post.tagged', owner: @user
          email_tagged_users(@user, post)
        end
      end 
    end
  end

  def email_tagged_users(user, post)
    SoapBoxMailer.tag_email(user, post, user.company.name).deliver  
  end

  def notify_commented_on
    @post = self.post
    self.create_activity key: 'comment.create', owner: @post.user
    SoapBoxMailer.comment_email(@post.user, self.user, @post, self.user.company.name).deliver
  end

  def notify_followee
    @following = self
    @following.create_activity key: 'following.create', owner: @following.followee
    SoapBoxMailer.following_email(@following.followee, @following.user, @following.user.company.name).deliver
  end

end