class AddAttributesToProjects < ActiveRecord::Migration[8.0]
  def change
    # 如果 area 已存在，則移除這行
    # add_column :projects, :area, :decimal, precision: 10, scale: 2

    # 如果 excavation_depth 已存在，請註解或移除下面這行
    # add_column :projects, :excavation_depth, :decimal, precision: 10, scale: 2

    # 只新增尚不存在的欄位
    add_column :projects, :area_unit, :string
    add_column :projects, :depth_unit, :string
    add_column :projects, :above_ground_floors, :integer
    add_column :projects, :above_floor_unit, :string
    add_column :projects, :below_ground_floors, :integer
    add_column :projects, :below_floor_unit, :string
  end
end
