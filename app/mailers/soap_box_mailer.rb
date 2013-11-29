class SoapBoxMailer < ActionMailer::Base
  default from: 'notifications@example.com'
  add_template_helper(ApplicationHelper)
 
  def welcome_email(user)
    @user = user
    # CR_Priyank: Why are we hardcoding route here ?
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def comment_email(user, commentor, post, company)
    @user = user
    @commentor = commentor
    @post = post
    @company = company
    mail(to: @user.email, subject:  @commentor.name.to_s +  ' commented on your Post')
  end

  def following_email(user, follower, company)
    @user = user
    @follower = follower
    @company = company
    mail(to: @user.email, subject: @follower.name.to_s  + ' started following you')
  end

  def tag_email(user, post, company)
    @user = user
    @post  = post
    @company = company
    mail(to: @user.email, subject: 'You got tagged')
  end


end
