// Entry point for the build script in your package.json
import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"
import "chartkick/chart.js"
const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
