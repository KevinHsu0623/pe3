class Project < ApplicationRecord
  # 每個專案屬於一個使用者
  belongs_to :user

  # 專案可有多筆材料使用紀錄
  has_many :material_usages, dependent: :destroy

  # 驗證
  validates :project_name, presence: true
  validates :project_type,  presence: true
  validates :location,      presence: true
  validates :area, numericality: true, allow_nil: true
  validates :excavation_depth, numericality: true, allow_nil: true
  validates :above_ground_floors, numericality: { only_integer: true }, allow_nil: true
  validates :below_ground_floors, numericality: { only_integer: true }, allow_nil: true

  # 計算各階段碳排放合計 (JOIN carbon_emissions 表)
  # 回傳格式: { "A1-A3" => 123.45, "A4-A5" => 678.90 }
  def emission_stats
    material_usages
      .joins(:carbon_emission)
      .group(:stage)
      .sum(Arel.sql("material_usages.quantity * carbon_emissions.carbon_emission_value"))
  end
end
