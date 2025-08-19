import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "results"]

  connect() {
    console.log("✅ material-search controller connected")
    this.inputTarget.addEventListener("input", () => this.search())
  }

  async search() {
    const keyword = this.inputTarget.value.trim()
    if (!keyword) {
      this.resultsTarget.innerHTML = ""
      return
    }

    const projectId = this.getProjectId()
    const res = await fetch(`/projects/${projectId}/material_usages/search.json?keyword=${encodeURIComponent(keyword)}`)
    const materials = await res.json()

    this.resultsTarget.innerHTML = materials.map(m =>
      `<li class="list-group-item" data-id="${m.id}" data-name="${m.item_name}">
        ${m.item_name} (${m.unit}, ${m.carbon_emission_value})
      </li>`
    ).join("")

    this.resultsTarget.querySelectorAll("li").forEach(item => {
      item.addEventListener("click", () => {
        this.inputTarget.value = item.dataset.name
        this.hiddenTarget.value = item.dataset.id
        this.resultsTarget.innerHTML = ""
      })
    })
  }

  getProjectId() {
    const path = window.location.pathname
    const match = path.match(/projects\/(\d+)/)
    return match ? match[1] : ""
  }
}
console.log("✅ material-search controller connected") // 開始就印

...

console.log("🚀 keyword:", keyword)
console.log("📤 request:", `/projects/${projectId}/material_usages/search.json?keyword=${keyword}`)

...

console.log("📥 搜尋結果：", materials)