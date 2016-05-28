class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :mobile_device?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def admin_signed_in?
    if user_signed_in?
      if current_user.role != "Admin"
        redirect_to root_url, notice: "We're sorry we couldn't find the page you were looking for!"
      end
    else
      redirect_to root_url, notice: "We're sorry we couldn't find the page you were looking for!"
    end
  end

  def after_sign_in_path_for(user)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_up_path_for(user)
    sign_up_url = new_user_registration_url
    if request.referer == sign_up_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def redirect_back_or_default
    redirect_to(session[:return_to] || root_url)
    session[:return_to] = nil
  end

  def disable_json
    if request.format.to_s =~ /json/ 
      redirect_to root_url, notice: "We're sorry we couldn't find the page you were looking for!"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "We're sorry but you're not allowed to access this page!"
    redirect_to root_url
  end

  helper_method :mobile_device?
  private

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :currency, :phone, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :currency, :phone, :email, :password, :password_confirmation, :current_password) }
  end
end
