class MaterialUsagesController < ApplicationController 
  before_action :authenticate_user!
  before_action :set_project

  # GET /projects/:project_id/material_usages
  def index
    @stage           = params[:stage] || "A1-A3"
    @material_usage  = MaterialUsage.new
    @material_usages = @project.material_usages.where(stage: @stage)
    @carbon_emissions = CarbonEmission.order(:item_name)
  end  # ✅ <<<<<< 加上這個 end！是解決錯誤的關鍵

  # POST /projects/:project_id/material_usages
  def create
    @material_usage = @project.material_usages.new(material_usage_params)
    if @material_usage.save
      next_stage = @material_usage.stage == "A1-A3" ? "A1-A3" : "A4-A5"
      redirect_to project_material_usages_path(@project, stage: next_stage),
                  notice: "材料已新增"
    else
      flash[:alert] = "新增失敗：請確認已選擇材料並輸入數量"
      redirect_to project_material_usages_path(@project, stage: material_usage_params[:stage])
    end
  end

  # GET /projects/:project_id/material_usages/search.json
  def search
  keyword = params[:keyword].to_s.strip
  results = if keyword.present?
    CarbonEmission.where("item_name ILIKE ?", "%#{keyword}%").limit(10)
  else
    []
  end
  render json: results.select(:id, :item_name, :unit, :carbon_emission_value)
end

def edit
  @material_usage = @project.material_usages.find(params[:id])
end

def update
  @material_usage = @project.material_usages.find(params[:id])
  if @material_usage.update(material_usage_params)
    redirect_to project_material_usages_path(@project, stage: @material_usage.stage),
                notice: "材料紀錄已更新"
  else
    flash.now[:alert] = "更新失敗"
    render :edit
  end
end

def destroy
  @material_usage = MaterialUsage.find(params[:id])
  project = @material_usage.project
  stage = @material_usage.stage
  @material_usage.destroy
  redirect_to project_material_usages_path(project, stage: stage), notice: "已成功刪除"
end

def show
  @project = Project.find(params[:project_id])
  @material_usage = @project.material_usages.find(params[:id])
end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def material_usage_params
    params.require(:material_usage).permit(:carbon_emission_id, :quantity, :stage)
  end
end
