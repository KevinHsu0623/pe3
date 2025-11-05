class AddExtendedFieldsForProjectTypes < ActiveRecord::Migration[8.0]
  def change
    change_table :projects, bulk: true do |t|
      # 下水道工程
      t.decimal :sewer_pipeline_length, precision: 12, scale: 2
      t.string  :sewer_pipeline_length_unit
      t.decimal :sewer_cross_section_area, precision: 12, scale: 2
      t.string  :sewer_cross_section_area_unit

      # 水利工程 - 護岸
      t.decimal :hydraulic_revetment_length, precision: 12, scale: 2
      t.string  :hydraulic_revetment_length_unit
      t.decimal :hydraulic_revetment_height, precision: 12, scale: 2
      t.string  :hydraulic_revetment_height_unit
      t.decimal :hydraulic_revetment_thickness, precision: 12, scale: 2
      t.string  :hydraulic_revetment_thickness_unit

      # 水利工程 - 樁基礎
      t.decimal :hydraulic_pile_length, precision: 12, scale: 2
      t.string  :hydraulic_pile_length_unit
      t.decimal :hydraulic_pile_cross_section_area, precision: 12, scale: 2
      t.string  :hydraulic_pile_cross_section_area_unit

      # 國道/公路工程 - 上部
      t.decimal :highway_superstructure_area, precision: 12, scale: 2
      t.string  :highway_superstructure_area_unit
      t.decimal :highway_superstructure_thickness, precision: 12, scale: 2
      t.string  :highway_superstructure_thickness_unit

      # 國道/公路工程 - 橋墩
      t.decimal :highway_pier_height, precision: 12, scale: 2
      t.string  :highway_pier_height_unit
      t.decimal :highway_pier_cross_section_area, precision: 12, scale: 2
      t.string  :highway_pier_cross_section_area_unit

      # 國道/公路工程 - 鋪面
      t.decimal :highway_pavement_area, precision: 12, scale: 2
      t.string  :highway_pavement_area_unit
      t.decimal :highway_pavement_thickness, precision: 12, scale: 2
      t.string  :highway_pavement_thickness_unit

      # 國道/公路工程 - 路基
      t.decimal :highway_subgrade_length, precision: 12, scale: 2
      t.string  :highway_subgrade_length_unit
      t.decimal :highway_subgrade_cross_section_area, precision: 12, scale: 2
      t.string  :highway_subgrade_cross_section_area_unit

      # 軌道工程
      t.decimal :rail_track_length, precision: 12, scale: 2
      t.string  :rail_track_length_unit

      # 水保 - 坡面工
      t.decimal :swc_slope_length, precision: 12, scale: 2
      t.string  :swc_slope_length_unit
      t.decimal :swc_slope_height, precision: 12, scale: 2
      t.string  :swc_slope_height_unit

      # 水保 - 籠工/石工
      t.decimal :swc_gabion_area, precision: 12, scale: 2
      t.string  :swc_gabion_area_unit
    end
  end
end
