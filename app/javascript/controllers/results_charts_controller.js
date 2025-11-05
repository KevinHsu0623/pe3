import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import ChartDataLabels from "chartjs-plugin-datalabels"

export default class extends Controller {
  static targets = ["combined", "a1a3", "a4a5", "stageComparison", "exportButton"]
  static values = {
    combinedLabels: Array,
    combinedData: Array,
    a1a3Labels: Array,
    a1a3Data: Array,
    a4a5Labels: Array,
    a4a5Data: Array,
    stageLabels: Array,
    stageData: Array,
    projectId: Number
  }

  connect() {
    if (!this.hasData()) return

    this.destroyCharts()
    Chart.register(ChartDataLabels)

    this.charts = [
      this.drawPie(this.combinedTarget, this.combinedLabelsValue, this.combinedDataValue),
      this.drawPie(this.a1a3Target, this.a1a3LabelsValue, this.a1a3DataValue),
      this.drawPie(this.a4a5Target, this.a4a5LabelsValue, this.a4a5DataValue),
      this.drawPie(this.stageComparisonTarget, this.stageLabelsValue, this.stageDataValue)
    ].filter(Boolean)

    if (this.hasExportButtonTarget) {
      this.exportListener = this.exportPdf.bind(this)
      this.exportButtonTarget.addEventListener("click", this.exportListener)
    }
  }

  disconnect() {
    this.destroyCharts()
    this.removeExportListener()
  }

  drawPie(canvas, labels, data) {
    if (!canvas || labels.length === 0) {
      return null
    }

    return new Chart(canvas, {
      type: "pie",
      data: {
        labels,
        datasets: [
          {
            data: data.map((value) => Number(value) || 0)
          }
        ]
      },
      options: {
        plugins: {
          datalabels: {
            formatter: (value, ctx) => {
              const values = ctx.chart.data.datasets[0].data
              const sum = values.reduce((acc, curr) => acc + Number(curr || 0), 0)
              if (sum <= 0) return "0%"
              return `${((Number(value) || 0) / sum * 100).toFixed(1)}%`
            },
            color: "#fff",
            font: { weight: "bold", size: 14 },
            anchor: "center",
            align: "center",
            clip: false
          }
        }
      },
      plugins: [ChartDataLabels]
    })
  }

  exportPdf() {
    const projectId = this.projectIdValue
    if (!projectId) return

    const chart = Chart.getChart(this.combinedTarget) || this.charts?.[0]
    const canvas = chart?.canvas || this.combinedTarget
    if (!canvas) return

    const imageData = canvas.toDataURL("image/png")
    const token = document.querySelector('meta[name="csrf-token"]')?.content

    fetch("/reports/upload_chart", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { "X-CSRF-Token": token } : {})
      },
      body: JSON.stringify({ project_id: projectId, image_data: imageData })
    }).then((response) => {
      if (response.ok) {
        window.location.href = `/projects/${projectId}/export.pdf`
      } else {
        alert("圖表上傳失敗，請稍後重試。")
      }
    }).catch(() => {
      alert("匯出請求失敗，請檢查網路連線。")
    })
  }

  hasData() {
    return window.Chart && window.ChartDataLabels && this.hasCombinedTarget && Array.isArray(this.combinedLabelsValue)
  }

  destroyCharts() {
    if (!this.charts) return
    this.charts.forEach((chart) => chart?.destroy())
    this.charts = []
  }

  removeExportListener() {
    if (this.hasExportButtonTarget && this.exportListener) {
      this.exportButtonTarget.removeEventListener("click", this.exportListener)
      this.exportListener = null
    }
  }
}
