Rails.application.routes.draw do
  # 健康檢查
  get "up", to: "rails/health#show", as: :rails_health_check

  # Carbon Emissions
  resources :carbon_emissions do
    collection do
      post :import
    end
  end

  # RailsAdmin 後台
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Devise
  devise_for :users, controllers: { sessions: "users/sessions" }

  # 登入頁為首頁
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # ✅ 專案 + 材料使用 + 結果報表
  resources :projects do
    get :results, on: :member
    resources :material_usages, only: [:index, :create]
  end
  get "/projects/:id/results.pdf", to: "projects#results", defaults: { format: :pdf }, as: :project_results_pdf
  # ✅ 缺少材料通報
  get  "/materials/request_missing", to: "materials#request_missing", as: :request_missing_materials
  post "/materials/send_request",    to: "materials#send_request",    as: :send_request_missing_materials
  
end
