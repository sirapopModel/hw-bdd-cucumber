class SessionsController < ApplicationController
    # login & logout actions should not require user to be logged in
    
    skip_before_filter :set_current_user
    def create
      auth = request.env["omniauth.auth"]
      user =
        Moviegoer.find_by(provider: auth["provider"], uid: auth["uid"]) ||
        Moviegoer.create_with_omniauth(auth)
      user_pic = auth.info.image
      session[:user_id] = user.id
      session[:user_pic] = user_pic
      flash[:notice] = 'Logged in successfully.'
      redirect_to movies_path
      #byebug
    end
    def destroy
      session.delete(:user_id)
      flash[:notice] = 'Logged out successfully.'
      redirect_to movies_path
    end
  end