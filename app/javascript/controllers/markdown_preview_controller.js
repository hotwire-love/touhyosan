// app/javascript/controllers/markdown_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "preview"]

  async update() {
    const response = await fetch("/markdown_preview", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: `text=${encodeURIComponent(this.editorTarget.value)}`
    })
    this.previewTarget.innerHTML = await response.text()
  }

  toggle(event) {
    this.editorTarget.classList.toggle("d-none")
    this.previewTarget.classList.toggle("d-none")

    if (!this.previewTarget.classList.contains("d-none")) {
      this.update()
    }
  }
}
