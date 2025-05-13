class MaterialUsagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def index
    @stage = params[:stage] || "A1-A3"
    @material_usage = MaterialUsage.new
    @material_usages = @project.material_usages.where(stage: @stage)
  end

  def create
    @material_usage = @project.material_usages.new(material_usage_params)
    if @material_usage.save
      # 決定下一步導向邏輯
      next_path = if @material_usage.stage == "A1-A3"
                    project_material_usages_path(@project, stage: "A1-A3")
                  elsif @material_usage.stage == "A4-A5"
                    project_material_usages_path(@project, stage: "A4-A5")
                  end
      redirect_to next_path, notice: "材料已新增"
    else
      redirect_to project_material_usages_path(@project, stage: @material_usage.stage), alert: "新增失敗"
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def material_usage_params
    params.require(:material_usage).permit(:carbon_emission_id, :quantity, :stage)
  end
end
