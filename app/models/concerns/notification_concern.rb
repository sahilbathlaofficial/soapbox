module NotificationConcern

  extend ActiveSupport::Concern

  def notify_tagged_users
    # CR_Priyank: We can also do is_a?(Post)
    post = self.class == Post ? self : self.post
    tags = self.tags
    if !tags.nil?
      user_ids = tags.split
      for user_id in user_ids
        # CR_Priyank: Do not use find
        @user = User.find(user_id)
        if !(@user.nil?)
          post.create_activity key: 'post.tagged', owner: @user
          email_tagged_users(@user, post)
        end
      end 
    end
  end

  # handle_asynchronously :notify_tagged_users

  def email_tagged_users(user, post)
    SoapBoxMailer.delay.tag_email(user, post, user.company.name) 
  end

  # handle_asynchronously :email_tagged_users

  def notify_commented_on
    @post = self.post
    self.create_activity key: 'comment.create', owner: @post.user
    SoapBoxMailer.delay.comment_email(@post.user, self.user, @post, self.user.company.name)
  end

  # handle_asynchronously :notify_commented_on, :run_at => Proc.new { 5.seconds.from_now }

  def notify_followee
    @following = self
    @following.create_activity key: 'following.create', owner: @following.followee
    SoapBoxMailer.delay.following_email(@following.followee, @following.user, @following.user.company.name)
  end

   # handle_asynchronously :notify_followee
end