import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    this.toast = new Toast(this.element)
    this.toast.show()
  }

  disconnect() {
    this.toast.dispose()
  }
}
