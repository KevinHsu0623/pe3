class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # 當使用 Devise 時，允許額外欄位，同時保留 email、password 等預設欄位
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email,
      :organization,
      :contact_name,
      :username
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :email,
      :organization,
      :contact_name,
      :username
    ])
  end

  # 登入後依據使用者角色跳轉：
  # 若 resource.role 為 "admin"（不區分大小寫），則跳轉至 rails_admin_path；否則跳轉至 new_project_path
  def after_sign_in_path_for(resource)
    if resource.role.to_s.downcase == "admin"
      rails_admin_path
    else
      new_project_path
    end
  end
end
