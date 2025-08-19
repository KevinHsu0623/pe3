class MaterialUsage < ApplicationRecord
  belongs_to :project
  belongs_to :carbon_emission

  validates :quantity, numericality: { greater_than: 0 }
  validates :stage, presence: true
  # 假設你在 carbon_emissions 表裡把係數欄位命名為 `emission_factor`
  # 如果你用其他名字（例如 coefficient、factor_value 等），請把下面這行改成對應欄位
  delegate :emission_factor, to: :carbon_emission

  # 一個實例方法，直接回傳本筆使用的碳排放量
  def emission
    quantity * emission_factor
  end
  def total_emission
    (carbon_emission.carbon_emission_value || 0) * (quantity || 0)
  end
end
