class MaterialUsage < ApplicationRecord
  belongs_to :project
  belongs_to :carbon_emission

  validates :quantity, numericality: { greater_than: 0 }
  validates :stage, presence: true

  def total_emission
    (carbon_emission.carbon_emission_value || 0) * (quantity || 0)
  end
end
