class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def activation_mail(user)
    @user = user
    #todo remove the const string
    @url = 'http://127.0.0.1:3000/users/activate/' + @user.activation_token
    mail(:to => @user.email, :subject => 'activation of your account')
    
  end
end

