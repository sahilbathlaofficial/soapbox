module NotificationConcern

  extend ActiveSupport::Concern

  def send_welcome_email
    SoapBoxMailer.delay.welcome_email(self)
  end

  def notify_tagged_users
    # CR_Priyank: We can also do is_a?(Post)
    # [Fixed] Using is_a?
    post = self.is_a?(Post) ? self : self.post
    tags = self.tags
    if !tags.nil?
      user_ids = tags.split
      for user_id in user_ids
        # CR_Priyank: Do not use find
        # [Fixed]: Removed
        @user = User.find_by(id: user_id)
        if (@user.present?)
          post.create_activity key: 'post.tagged', owner: @user
          email_tagged_users(@user, post)
        end
      end 
    end
  end


  def email_tagged_users(user, post)
    SoapBoxMailer.delay.tag_email(user, post, user.company.name) 
  end


  def notify_commented_on
    @post = self.post
    self.create_activity key: 'comment.create', owner: @post.user
    SoapBoxMailer.delay.comment_email(@post.user, self.user, @post, self.user.company.name)
  end


  def notify_followee
    @following = self
    @following.create_activity key: 'following.create', owner: @following.followee
    SoapBoxMailer.delay.following_email(@following.followee, @following.user, @following.user.company.name)
  end

end