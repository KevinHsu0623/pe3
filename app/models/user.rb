# app/models/user.rb
class User < ApplicationRecord
  # Devise...
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # 讓 user 可以有多個專案
  has_many :projects, dependent: :destroy

  # 管理員判斷方法，改成 ? 結尾更慣用
  def admin?
    role.to_s.downcase == "admin"
  end
end