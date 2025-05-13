class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string  :project_name
      t.string  :project_type
      t.string  :location
      t.decimal :area
      t.integer :floors_above
      t.integer :floors_below
      t.decimal :excavation_depth

      t.timestamps
    end
  end
end
