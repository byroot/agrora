class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def activation_mail(user)
    @user = user
    mail(:to => @user.email, :subject => 'activation of your account')
    
  end
end

