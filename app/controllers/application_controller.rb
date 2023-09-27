class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
protect_from_forgery with: :exception

before_filter :set_current_user
protected # prevents method from being invoked by a route 
def set_current_user
# we exploit the fact that the below query may return nil
  @current_user ||= Moviegoer.find_by(:id => session[:user_id]) 
#redirect_to login_path return unless @current_user 
end
helper_method :set_current_user
end
