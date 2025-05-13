class Project < ApplicationRecord
    validates :project_name, presence: true
    validates :project_type, presence: true
    validates :area, numericality: true, allow_nil: true
    validates :excavation_depth, numericality: true, allow_nil: true
    validates :above_ground_floors, numericality: { only_integer: true }, allow_nil: true
    validates :below_ground_floors, numericality: { only_integer: true }, allow_nil: true
    has_many :material_usages, dependent: :destroy
end
  