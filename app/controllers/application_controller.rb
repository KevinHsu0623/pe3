# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # 註冊與更新時允許的額外欄位
  def configure_permitted_parameters
    lists = [:email, :organization, :contact_name, :username]
    devise_parameter_sanitizer.permit(:sign_up,        keys: lists)
    devise_parameter_sanitizer.permit(:account_update, keys: lists)
  end

  # 登入後導向
  # 管理員進入後台，其餘使用者進入專案列表
  def after_sign_in_path_for(resource)
    if resource.respond_to?(:admin?) && resource.admin?
      rails_admin_path
    else
      projects_path
    end
  end
end
