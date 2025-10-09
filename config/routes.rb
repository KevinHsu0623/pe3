# config/routes.rb
Rails.application.routes.draw do
  # 健康檢查
  get "up", to: "rails/health#show", as: :rails_health_check

  # 報告圖表：上傳匯出的 Canvas 圖檔（供 PDF 使用）
  # 例：POST /reports/upload_chart
  post "/reports/upload_chart", to: "reports#upload_chart", as: :upload_chart

  # 缺少材料通報
  get  "/materials/request_missing", to: "materials#request_missing", as: :request_missing_materials
  post "/materials/send_request",    to: "materials#send_request",    as: :send_request_missing_materials

  # Carbon Emissions（材料碳排）資源 + 匯入 / 搜尋 / 範本下載
  resources :carbon_emissions do
    collection do
      post :import                 # POST /carbon_emissions/import
      get  :import_template        # GET  /carbon_emissions/import_template
      get  :search                 # GET  /carbon_emissions/search
    end
  end

  # RailsAdmin 後台
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  # Devise 使用者認證
  devise_for :users, controllers: { sessions: "users/sessions" }

  # 首頁：未登入導向登入頁；已登入導向專案列表
  authenticated :user do
    root to: "projects#index", as: :authenticated_root
  end
  unauthenticated do
    root to: "devise/sessions#new", as: :unauthenticated_root
  end

  # 專案 + Nested 資源
  resources :projects do
    member do
      # HTML 結果頁
      get :results
      # PDF 結果頁（修正命名，避免與上面重複）
      get :results_pdf, to: "projects#results", defaults: { format: :pdf }
      # 完整報告 PDF 匯出
      get :export, to: "reports#export", defaults: { format: :pdf }
    end

    # 材料使用（若之後仍遇到 /projects/:id/material_usages/:id show 404，可把 :show 移除拿掉或改成 only: [:index, :new, :create, :edit, :update, :destroy]）
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
