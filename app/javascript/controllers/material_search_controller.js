import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "results", "info"]
  static values = { projectId: String }

  connect() {
    this.clearResults()
    this.clearInfo()
  }

  async search() {
    const keyword = this.inputTarget.value.trim()

    if (!keyword) {
      this.clearResults()
      this.clearInfo()
      return
    }
    const projectId = this.projectId
    if (!projectId) return

    try {
      const response = await fetch(`/projects/${projectId}/material_usages/search.json?keyword=${encodeURIComponent(keyword)}`)
      if (!response.ok) throw new Error(`HTTP ${response.status}`)

      const materials = await response.json()
      this.renderResults(Array.isArray(materials) ? materials : [])
    } catch (error) {
      console.error("Material search failed:", error)
      this.clearResults()
    }
  }

  preventSubmit(event) {
    if (event.key === "Enter") {
      event.preventDefault()
    }
  }

  resetAfterSubmit(event) {
    if (event.type === "submit") return
    if (event.detail?.success === false) return

    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    this.clearResults()
    this.clearInfo()
  }

  renderResults(materials) {
    this.clearResults()

    if (materials.length === 0) {
      this.resultsTarget.innerHTML = `<li class="list-group-item text-muted">查無資料</li>`
      return
    }

    materials.forEach(material => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "list-group-item list-group-item-action text-start"
      button.textContent = `${material.item_name} (${material.unit}, ${material.carbon_emission_value})`

      Object.entries({
        id: material.id,
        name: material.item_name,
        unit: material.unit,
        value: material.carbon_emission_value,
        category: material.category || "",
        region: material.region || "",
        date: material.published_date || ""
      }).forEach(([key, value]) => button.dataset[key] = value)

      button.addEventListener("click", () => this.selectMaterial(button.dataset))
      this.resultsTarget.appendChild(button)
    })
  }

  selectMaterial(data) {
    this.inputTarget.value = data.name || ""
    this.hiddenTarget.value = data.id || ""
    this.clearResults()
    this.updateInfo(data)
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
  }

  updateInfo(data) {
    if (!this.hasInfoTarget) return

    if (!data.name) {
      this.clearInfo()
      return
    }

    this.infoTarget.innerHTML = `
      選擇材料：<strong>${data.name}</strong><br>
      類別：${data.category || "—"}｜地區：${data.region || "—"}｜公告年份：${data.date || "—"}<br>
      單位：${data.unit || "—"}｜碳排係數：${data.value || "—"} kgCO₂e/${data.unit || ""}
    `
  }

  clearInfo() {
    if (this.hasInfoTarget) this.infoTarget.innerHTML = ""
  }

  get projectId() {
    if (this.hasProjectIdValue) return this.projectIdValue
    const path = window.location.pathname
    const match = path.match(/projects\/(\d+)/)
    return match ? match[1] : ""
  }
}
