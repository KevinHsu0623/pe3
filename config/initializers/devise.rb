# frozen_string_literal: true

# config/initializers/devise.rb
#
# 以下設定檔調整 Devise 使用 username 作為認證依據，
# 並設定其它常用參數。請根據您的需求進行調整。

Devise.setup do |config|
  # 設定寄件者信箱 (請修改為您實際使用的信箱)
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # 載入 Active Record ORM 的 Devise 模組
  require 'devise/orm/active_record'

  # ---------------------------
  # 認證鍵相關設定
  # ---------------------------
  # 使用 username 作為認證鍵
  config.authentication_keys = [:username]
  
  # 驗證時將 username 自動轉成小寫，避免大小寫造成誤差
  config.case_insensitive_keys = [:username]
  
  # 驗證時自動移除 username 前後空白
  config.strip_whitespace_keys = [:username]

  # ---------------------------
  # Session 與密碼加密設定
  # ---------------------------
  # 不儲存 HTTP 認證的 session
  config.skip_session_storage = [:http_auth]

  # 密碼加密運算次數，測試環境設為 1，其它環境建議保持在 12 或更高
  config.stretches = Rails.env.test? ? 1 : 12

  # ---------------------------
  # Confirmable 模組設定（若有啟用）
  # ---------------------------
  # 若使用 confirmable，要求使用者必須確認 username 對應的 email
  config.reconfirmable = true

  # ---------------------------
  # Rememberable 模組設定
  # ---------------------------
  # 登出時使所有 remember me token 失效
  config.expire_all_remember_me_on_sign_out = true

  # ---------------------------
  # 密碼驗證相關設定
  # ---------------------------
  # 密碼長度範圍，至少 6 字元，最多 128 字元
  config.password_length = 6..128

  # 用來驗證 email 格式的正規表示式（若您仍保留 email 欄位）
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ---------------------------
  # 密碼重設相關設定
  # ---------------------------
  # 設定重設密碼的有效期限，這裡設定為 6 小時
  config.reset_password_within = 6.hours

  # ---------------------------
  # 登出相關設定
  # ---------------------------
  # 設定登出時使用的 HTTP 方法，預設為 :delete
  config.sign_out_via = :delete

  # ---------------------------
  # Hotwire/Turbo 設定
  # ---------------------------
  # 當使用 Hotwire/Turbo 時，錯誤回應與重導的 HTTP 狀態設定
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
