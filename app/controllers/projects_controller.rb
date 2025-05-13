class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :results]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to project_material_usages_path(@project, stage: "A1-A3")
    else
      render :new
    end
  end

  def results
    @usages = @project.material_usages.includes(:carbon_emission)
    @total_emission = @usages.sum(&:total_emission).to_f
  
    @top10 = @usages
      .group_by { |u| u.carbon_emission.item_name }
      .transform_values { |records| records.sum(&:total_emission).to_f }
      .sort_by { |_, v| -v }
      .first(10)
  
    @emission_per_area = @project.area.to_f > 0 ? (@total_emission / @project.area.to_f) : nil
  
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "project_results",
               template: "projects/results.pdf.erb",
               layout: "pdf.html",   # 可自訂列印樣式
               encoding: "UTF-8"
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :project_name,
      :project_type,
      :location,
      :area,
      :floors_above,
      :floors_below,
      :excavation_depth
    )
  end
end
