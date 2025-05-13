class User < ApplicationRecord
  # 使用 Devise 常見的模組，可根據需要調整其他模組
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 驗證 username 必填且唯一（忽略大小寫）
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # 定義 admin? 方法：當 role 欄位（字串）為 "admin"（不區分大小寫）時，返回 true
  def admin
    role.to_s.downcase == "admin"
  end
end
