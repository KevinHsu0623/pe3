class Project < ApplicationRecord
  ROAD_ENGINEERING_NEW = "道路工程".freeze
  ROAD_ENGINEERING_OLD = "鋪面工程".freeze
  SOIL_WATER_ENGINEERING_OLD = "水保".freeze

  PROJECT_TYPES = [
    "建築工程",
    ROAD_ENGINEERING_NEW,
    "下水道工程",
    "水利工程",
    "國道/公路工程",
    "軌道工程",
    "水保工程",
    "其他工程"
  ].freeze

  PROJECT_TYPE_ALLOWLIST = (PROJECT_TYPES + [ROAD_ENGINEERING_OLD, SOIL_WATER_ENGINEERING_OLD]).freeze

  LENGTH_UNITS = {
    "cm" => "公分 (cm)",
    "m"  => "公尺 (m)",
    "ft" => "英尺 (ft)"
  }.freeze

  AREA_UNITS = {
    "cm2" => "平方公分 (cm²)",
    "m2"  => "平方公尺 (m²)",
    "ft2" => "平方英尺 (ft²)"
  }.freeze

  VOLUME_UNITS = {
    "cm3" => "立方公分 (cm³)",
    "m3"  => "立方公尺 (m³)",
    "ft3" => "立方英尺 (ft³)"
  }.freeze

  SPECIAL_UNIT_LABELS = {
    "floor" => "層"
  }.freeze

  UNIT_LABELS = LENGTH_UNITS
                  .merge(AREA_UNITS)
                  .merge(VOLUME_UNITS)
                  .merge(SPECIAL_UNIT_LABELS)
                  .freeze

  PROJECT_TYPE_DISPLAY_MAP = {
    ROAD_ENGINEERING_OLD => ROAD_ENGINEERING_NEW,
    SOIL_WATER_ENGINEERING_OLD => "水保工程"
  }.freeze

  # 每個專案屬於一個使用者
  belongs_to :user

  # 專案可有多筆材料使用紀錄
  has_many :material_usages, dependent: :destroy

  # 驗證
  validates :project_name, presence: true
  validates :project_type, presence: true, inclusion: { in: PROJECT_TYPE_ALLOWLIST }
  validates :location,     presence: true

  validates :area, numericality: { greater_than: 0 }, allow_nil: true
  validates :excavation_depth, numericality: { greater_than: 0 }, allow_nil: true
  validates :above_ground_floors, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :below_ground_floors, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  with_options if: :sewer_engineering? do
    validates :sewer_pipeline_length, numericality: { greater_than: 0 }
    validates :sewer_pipeline_length_unit, presence: true
    validates :sewer_cross_section_area, numericality: { greater_than: 0 }
    validates :sewer_cross_section_area_unit, presence: true
  end

  with_options if: :hydraulic_engineering? do
    validates :hydraulic_revetment_length, numericality: { greater_than: 0 }
    validates :hydraulic_revetment_length_unit, presence: true
    validates :hydraulic_revetment_height, numericality: { greater_than: 0 }
    validates :hydraulic_revetment_height_unit, presence: true
    validates :hydraulic_revetment_thickness, numericality: { greater_than: 0 }
    validates :hydraulic_revetment_thickness_unit, presence: true
    validates :hydraulic_pile_length, numericality: { greater_than: 0 }
    validates :hydraulic_pile_length_unit, presence: true
    validates :hydraulic_pile_cross_section_area, numericality: { greater_than: 0 }
    validates :hydraulic_pile_cross_section_area_unit, presence: true
  end

  with_options if: :highway_engineering? do
    validates :highway_superstructure_area, numericality: { greater_than: 0 }
    validates :highway_superstructure_area_unit, presence: true
    validates :highway_superstructure_thickness, numericality: { greater_than: 0 }
    validates :highway_superstructure_thickness_unit, presence: true

    validates :highway_pier_height, numericality: { greater_than: 0 }
    validates :highway_pier_height_unit, presence: true
    validates :highway_pier_cross_section_area, numericality: { greater_than: 0 }
    validates :highway_pier_cross_section_area_unit, presence: true

    validates :highway_pavement_area, numericality: { greater_than: 0 }
    validates :highway_pavement_area_unit, presence: true
    validates :highway_pavement_thickness, numericality: { greater_than: 0 }
    validates :highway_pavement_thickness_unit, presence: true

    validates :highway_subgrade_length, numericality: { greater_than: 0 }
    validates :highway_subgrade_length_unit, presence: true
    validates :highway_subgrade_cross_section_area, numericality: { greater_than: 0 }
    validates :highway_subgrade_cross_section_area_unit, presence: true
  end

  with_options if: :rail_engineering? do
    validates :rail_track_length, numericality: { greater_than: 0 }
    validates :rail_track_length_unit, presence: true
  end

  with_options if: :soil_water_engineering? do
    validates :swc_slope_length, numericality: { greater_than: 0 }
    validates :swc_slope_length_unit, presence: true
    validates :swc_slope_height, numericality: { greater_than: 0 }
    validates :swc_slope_height_unit, presence: true
    validates :swc_gabion_area, numericality: { greater_than: 0 }
    validates :swc_gabion_area_unit, presence: true
  end

  # 計算各階段碳排放合計 (JOIN carbon_emissions 表)
  # 回傳格式: { "A1-A3" => 123.45, "A4-A5" => 678.90 }
  def emission_stats
    material_usages
      .joins(:carbon_emission)
      .group(:stage)
      .sum(Arel.sql("material_usages.quantity * carbon_emissions.carbon_emission_value"))
  end

  def project_type_display
    PROJECT_TYPE_DISPLAY_MAP.fetch(project_type, project_type)
  end

  def road_engineering?
    project_type_display == ROAD_ENGINEERING_NEW
  end

  def sewer_engineering?
    project_type_display == "下水道工程"
  end

  def hydraulic_engineering?
    project_type_display == "水利工程"
  end

  def highway_engineering?
    project_type_display == "國道/公路工程"
  end

  def rail_engineering?
    project_type_display == "軌道工程"
  end

  def soil_water_engineering?
    project_type_display == "水保工程"
  end

  def self.project_type_options
    PROJECT_TYPES.map { |type| [type, type] }
  end

  def self.unit_label(code)
    UNIT_LABELS[code]
  end

  def unit_label(code)
    self.class.unit_label(code)
  end

  def formatted_measurement(value, unit)
    return nil if value.blank?

    numeric_value = value.to_f
    number =
      if numeric_value == numeric_value.to_i
        numeric_value.to_i
      else
        (numeric_value * 100).round / 100.0
      end

    label  = unit_label(unit)

    label.present? ? "#{number} #{label}" : number.to_s
  end
end
