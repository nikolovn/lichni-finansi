class ApplicationController < ActionController::Base
  before_action :set_locale
 
  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = cookies[:locale] || I18n.default_locale
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


   rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Access denied.'
    redirect_to main_app.root_url
  end


  def user
    user = current_user
    
    if current_user.admin? 
      user = params['user_id'].present? ? User.find(params['user_id']) : current_user
    end
    
    user 
  end
end