import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hiddenInput", "unitDisplay", "unitHolder"]
  static values = { url: String }

  connect() {
    this.inputTarget.addEventListener("input", this.search.bind(this))

    // 防止按 Enter 時表單直接送出
    this.inputTarget.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault()
      }
    })
  }

  search() {
    const q = this.inputTarget.value.trim()
    if (q.length < 1) {
      this.clearResults()
      return
    }

    fetch(`${this.urlValue}?q=${encodeURIComponent(q)}`)
      .then(r => r.json())
      .then(data => {
        this.resultsTarget.innerHTML = ""
        data.forEach(item => {
          const el = document.createElement("button")
          el.type = "button"
          el.className = "dropdown-item text-start"
          el.textContent = `${item.item_name}（單位：${item.unit}，碳排：${item.carbon_emission_value} kgCO₂e）`
          el.dataset.id = item.id
          el.dataset.unit = item.unit
          el.dataset.name = item.item_name
          el.addEventListener("click", () => this.select(item))
          this.resultsTarget.appendChild(el)
        })
        this.resultsTarget.classList.add("show")
      })
  }

  select(item) {
    this.inputTarget.value = item.item_name
    this.hiddenInputTarget.value = item.id
    this.unitHolderTarget.value = item.unit
    this.unitDisplayTarget.textContent = item.unit || ""
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.remove("show")
  }
}
