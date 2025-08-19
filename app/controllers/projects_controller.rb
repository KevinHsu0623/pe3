# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  # 只在這幾個 action 前載入專案
  before_action :set_project, only: %i[show edit update destroy results]

  # GET /projects
  def index
    @projects = current_user.admin? ? Project.all : current_user.projects
  end

  # GET /projects/:id
  def show
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
  end

  # POST /projects
  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to project_material_usages_path(@project, stage: 'A1-A3'), notice: '專案建立成功'
    else
      render :new
    end
  end

  # GET /projects/:id/edit
  # 直接導向到材料盤查頁
  def edit
    redirect_to project_material_usages_path(@project, stage: 'A1-A3')
  end

  # PATCH/PUT /projects/:id
  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: '專案更新成功'
    else
      redirect_to project_material_usages_path(@project, stage: 'A1-A3'), alert: '資料更新失敗'
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    redirect_to projects_path, notice: '專案已刪除'
  end

  # GET /projects/:id/results (HTML & PDF)
  def results
    # 1. 所有材料使用紀錄
    @usages = @project.material_usages.includes(:carbon_emission)

    # 2. 各階段統計
    @stats = @project.emission_stats

    # 3. 全案總排放及單位面積排放
    @total_emission = @usages.sum { |mu| mu.quantity.to_f * mu.carbon_emission.carbon_emission_value.to_f }.round(2)
    @emission_per_area = (@total_emission / @project.area.to_f).round(2) if @project.area.to_f.positive?

    # 4. 合併相同項目後的材料總表
    grouped = @usages.group_by { |mu| mu.carbon_emission.item_name }
    @mat_rows = grouped.map do |name, arr|
      total_qty = arr.sum(&:quantity)
      factor    = arr.first.carbon_emission.carbon_emission_value
      unit      = arr.first.carbon_emission.unit
      total_em  = (total_qty.to_f * factor.to_f).round(2)
      [name, factor, "#{total_qty} #{unit}", total_em]
    end

    # 5. 排放量前 5 名
    totals = @mat_rows.map { |name, _, _, em| [name, em] }.to_h
    @top5  = totals.sort_by { |_n, v| -v }.first(5)

    # 6. A1-A3 階段前 5 名
    a1_arr = @usages.select { |mu| mu.stage == 'A1-A3' }
    a1_grouped = a1_arr.group_by { |mu| mu.carbon_emission.item_name }
    h1 = a1_grouped.transform_values { |arr| arr.sum { |mu| mu.quantity.to_f * mu.carbon_emission.carbon_emission_value.to_f } }
    @a1a3_top   = h1.sort_by { |_n, v| -v }.first(5)
    @a1a3_total = h1.values.sum.round(2)

    # 7. A4-A5 階段前 5 名
    a4_arr = @usages.select { |mu| mu.stage == 'A4-A5' }
    a4_grouped = a4_arr.group_by { |mu| mu.carbon_emission.item_name }
    h2 = a4_grouped.transform_values { |arr| arr.sum { |mu| mu.quantity.to_f * mu.carbon_emission.carbon_emission_value.to_f } }
    @a4a5_top   = h2.sort_by { |_n, v| -v }.first(5)
    @a4a5_total = h2.values.sum.round(2)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf:      "#{@project.project_name.parameterize}_report",
               template: 'projects/results',
               layout:   'pdf',
               page_size:  'A4',
               margin:     { top:20, bottom:20, left:20, right:20 },
               encoding:   'UTF-8',
               dpi:        '300'
      end
    end
  end

  private

  def set_project
    @project = current_user.admin? ? Project.find(params[:id]) : current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :project_name, :project_type, :location,
      :area, :area_unit,
      :excavation_depth, :depth_unit,
      :above_ground_floors, :above_floor_unit,
      :below_ground_floors, :below_floor_unit
    )
  end
end
