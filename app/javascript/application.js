// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import "chartkick/chart.js"
export const application = Application.start()

import "./project_form"
import "./controllers"
