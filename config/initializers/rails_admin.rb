RailsAdmin.config do |config|
  config.asset_source = :importmap

  # Devise 認證
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  # 角色限制，僅允許 role 為 "admin" 的使用者
  config.authorize_with do
    unless current_user && current_user.role == "admin"
      redirect_to main_app.new_user_session_path, alert: "您沒有管理者權限！"
    end
  end
end
