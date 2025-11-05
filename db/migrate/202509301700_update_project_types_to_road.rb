class UpdateProjectTypesToRoad < ActiveRecord::Migration[7.1]
  class Project < ApplicationRecord
    self.table_name = "projects"
  end

  def up
    Project.where(project_type: "鋪面工程").update_all(project_type: "道路工程")
  end

  def down
    Project.where(project_type: "道路工程").update_all(project_type: "鋪面工程")
  end
end
