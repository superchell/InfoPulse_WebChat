class LoginController < ApplicationController
  def index
    if session[:error]!=nil
      @error=session[:error]
      session[:error]=nil
    end

  end

  def create
    login = params[:l]
    password = params[:p]
    u = ChatUser.find_by_login(login)

    if u !=nil && u.password == password
      session[:login] = u.login
    else
      session[:error] = 'Login of password incorect'
      redirect_to login_index_path
      return
    end

    if u.role.rolename == 'ADMIN'
      redirect_to admin_index_path
      return
    end

    redirect_to chat_index_path

  end

end
