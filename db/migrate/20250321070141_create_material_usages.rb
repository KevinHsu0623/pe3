class CreateMaterialUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :material_usages do |t|
      t.references :project, null: false, foreign_key: true
      t.references :carbon_emission, null: false, foreign_key: true
      t.decimal :quantity
      t.string :stage

      t.timestamps
    end
  end
end
