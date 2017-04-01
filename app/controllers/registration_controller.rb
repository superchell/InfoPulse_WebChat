class RegistrationController < ApplicationController
  def index

    unless session[:error] == nil
      @error = session[:error]
      session[:error] = nil
    end

    @chat_user = ChatUser.new
  end

  def create
    new_user = ChatUser.new(registration_params)

    if new_user.save
      redirect_to '/'
    else
      session[:error] = 'Bad login'
      redirect_to registration_index_path
    end

  end


  private

  def registration_params
    params.require(:chat_user).permit(:name, :login, :password)
  end
end
