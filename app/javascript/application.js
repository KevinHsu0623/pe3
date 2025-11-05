// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import ChartDataLabels from "chartjs-plugin-datalabels"
import "chartkick/chart.js"

Chart.register(ChartDataLabels)
window.Chart = Chart
window.ChartDataLabels = ChartDataLabels

export const application = Application.start()

import "./project_form"
import "./controllers"
