class SoapBoxMailer < ActionMailer::Base
  default from: 'notifications@example.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def comment_email(user, commentor, post)
    @user = user
    @commentor = commentor
    @post = post
    mail(to: @user.email, subject:  @commentor.name.to_s +  ' commented on your Post')
  end

  def following_email(user, follower)
    @user = user
    @follower = follower
    mail(to: @user.email, subject: @follower.name.to_s  + ' started following you')
  end

  def tag_email(user, post)
    @user = user
    @post  = post
    mail(to: @user.email, subject: 'You got tagged')
  end

end
