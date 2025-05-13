class CreateCarbonEmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :carbon_emissions do |t|
      t.string :item_name
      t.string :category
      t.string :period_range
      t.string :production_area
      t.decimal :carbon_emission_value
      t.string :unit
      t.datetime :announcement_date

      t.timestamps
    end
  end
end
