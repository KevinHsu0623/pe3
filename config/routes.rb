Rails.application.routes.draw do
  # 健康檢查
  get "up", to: "rails/health#show", as: :rails_health_check

  # 匯出圖表圖片 (報告圖表)
  

  # 缺少材料通報
  get  "/materials/request_missing", to: "materials#request_missing", as: :request_missing_materials
  post "/materials/send_request",    to: "materials#send_request",    as: :send_request_missing_materials

  # Carbon Emissions 資源與匯入＆搜尋
  resources :carbon_emissions, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      post :import
      get  :search
    end
  end

  # RailsAdmin 後台
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Devise 使用者認證
  devise_for :users, controllers: { sessions: "users/sessions" }

  # 未登入時的首頁
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # 專案 + Nested 資源
  resources :projects do
    member do
      # HTML 結果頁
      get :results
      # PDF 結果頁
      get :results, to: 'projects#results', defaults: { format: :pdf }, as: :results_pdf
      # 完整報告 PDF 匯出
      get :export,  to: 'reports#export',  defaults: { format: :pdf }
    end

    # 材料使用
    resources :material_usages, except: [:show] do
      collection { get :search }
    end

    # 機具搜尋
    resources :equipments, only: [] do
      collection { get :search }
    end

    # 運輸方式搜尋
    resources :transportation_methods, only: [] do
      collection { get :search }
    end
  end
end
