class ReportsController < ApplicationController
  require "base64"

  def export
    @project = Project.find(params[:id])
    @user    = current_user

    usages = @project.material_usages.includes(:carbon_emission)

    # === (1) 碳排統計資料 ===
    @stats = usages
             .joins(:carbon_emission)
             .group(:stage)
             .sum("quantity * carbon_emissions.carbon_emission_value")

    # === (2) 排放明細表 ===
    @material_rows = usages.select { |u| u.carbon_emission.category == '材料' }.map do |m|
      coef     = m.carbon_emission.carbon_emission_value
      emission = (m.quantity * coef).round(2)
      [
        m.carbon_emission.item_name,
        coef,
        "#{m.quantity} #{m.carbon_emission.unit}",
        sprintf('%.2f', emission)
      ]
    end

    @equipment_rows = usages.select { |u| u.carbon_emission.category == '機具' }.map do |m|
      coef     = m.carbon_emission.carbon_emission_value
      emission = (m.quantity * coef).round(2)
      [
        m.carbon_emission.item_name,
        coef,
        "#{m.quantity} #{m.carbon_emission.unit}",
        sprintf('%.2f', emission)
      ]
    end

    @combined_rows = @material_rows + @equipment_rows

    # === (3) 排放前五名材料 ===
    @total_emission = @stats.values.sum
    @top5_data = usages
                 .joins(:carbon_emission)
                 .group("carbon_emissions.item_name")
                 .order(Arel.sql("SUM(quantity * carbon_emissions.carbon_emission_value) DESC"))
                 .limit(5)
                 .pluck(
                   Arel.sql("carbon_emissions.item_name"),
                   Arel.sql("SUM(quantity * carbon_emissions.carbon_emission_value)")
                 )

    # === (4) 回應格式 ===
    respond_to do |format|
      format.html # 可在瀏覽器預覽
      format.pdf do
        render pdf:       "project_report_#{@project.id}",
               template:  "reports/export",
               layout:    "pdf",
               page_size: "A4",
               margin:    { top: 20, bottom: 20, left: 20, right: 20 },
               encoding:  "UTF-8",
               dpi:       "300"
      end
    end
  end

  def upload_chart
  image_data = params[:image_data]
  project_id = params[:project_id]

  if image_data.present?
    File.open(Rails.root.join("public", "piechart_combined_#{project_id}.png"), "wb") do |file|
      file.write(Base64.decode64(image_data.split(",")[1]))
    end
    head :ok
  else
    head :bad_request
  end
end
end