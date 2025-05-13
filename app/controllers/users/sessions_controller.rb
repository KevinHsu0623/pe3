# app/controllers/users/sessions_controller.rb
module Users
  class SessionsController < Devise::SessionsController
    # 讓 new 動作即使在已登入狀態下也不會自動重定向
    skip_before_action :require_no_authentication, only: [:new]

    def new
      # 初始化登入資源
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      respond_with(resource, serialize_options(resource))
    end
  end
end
