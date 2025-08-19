class CarbonEmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:import]  # 僅限管理員匯入
  before_action :set_carbon_emission, only: %i[show edit update destroy]

  # GET /carbon_emissions
  def index
    @carbon_emissions = CarbonEmission.all
  end

  # GET /carbon_emissions/1
  def show
  end

  # GET /carbon_emissions/new
  def new
    @carbon_emission = CarbonEmission.new
  end

  # GET /carbon_emissions/1/edit
  def edit
  end

  # POST /carbon_emissions
  def create
    @carbon_emission = CarbonEmission.new(carbon_emission_params)

    respond_to do |format|
      if @carbon_emission.save
        format.html { redirect_to @carbon_emission, notice: "Carbon emission was successfully created." }
        format.json { render :show, status: :created, location: @carbon_emission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @carbon_emission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carbon_emissions/1
  def update
    respond_to do |format|
      if @carbon_emission.update(carbon_emission_params)
        format.html { redirect_to @carbon_emission, notice: "Carbon emission was successfully updated." }
        format.json { render :show, status: :ok, location: @carbon_emission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @carbon_emission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carbon_emissions/1
  def destroy
    @carbon_emission.destroy!

    respond_to do |format|
      format.html { redirect_to carbon_emissions_path, status: :see_other, notice: "Carbon emission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /carbon_emissions/import
  def import
    file = params[:file]

    if file.blank?
      redirect_to carbon_emissions_path, alert: "請選擇檔案"
      return
    end

    begin
      spreadsheet = Roo::Spreadsheet.open(file.path)
      header = spreadsheet.row(1)

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        CarbonEmission.create!(
          item_name:             row["品項名稱"],
          category:              row["產品類別"],
          period_range:          row["週期範圍"],
          production_area:       row["生產區域"],
          carbon_emission_value: row["碳排數值"],
          unit:                  row["單位"],
          announcement_date: parse_announcement_date(row["公告時間"])
          )
      end

      redirect_to carbon_emissions_path, notice: "匯入成功！"
    rescue => e
      redirect_to carbon_emissions_path, alert: "匯入失敗：#{e.message}"
    end
  end

  private

  def set_carbon_emission
    @carbon_emission = CarbonEmission.find(params[:id])
  end

  def carbon_emission_params
    params.require(:carbon_emission).permit(
      :item_name, :category, :period_range, :production_area,
      :carbon_emission_value, :unit, :announcement_date
    )
  end

  def check_admin
    unless current_user.role == "admin"
      redirect_to root_path, alert: "您沒有權限執行此操作！"
    end
  end
end
def parse_announcement_date(value)
  return nil if value.blank?

  if value.is_a?(Date) || value.is_a?(Time)
    value
  elsif value.to_s.match?(/^\d{4}$/)
    # 如果是年份（例如 2020），轉成 2020-01-01
    Date.new(value.to_i, 1, 1)
  else
    # 其他格式嘗試轉成日期（例如 2023/01/15）
    Date.parse(value.to_s) rescue nil
  end
end

def search
  query = params[:q].to_s.strip
  results = CarbonEmission
              .where("item_name ILIKE ?", "%#{query}%")
              .limit(10)
              .select(:id, :item_name, :unit, :carbon_emission_value)

  render json: results
end
