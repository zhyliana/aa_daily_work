class UserMailer < ActionMailer::Base
  default from: "sample_email@gmail.com"
  
  def welcome_email(user)
    @user = user
    @url = "localhost:3000/session/new"
    attachments['filename.jpg'] = File.read('/Desktop/filename.jpg')
    mail(to: user.email, cc: other@mail.com, subject: "Welcome to Keep a Kitty")
  end
  
  def reminder_email(user)
    #... other emails
  end

end
