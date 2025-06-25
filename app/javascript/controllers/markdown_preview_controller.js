import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "preview", "previewForm", "previewFormInput"]

  update() {
    this.previewFormInputTarget.value = this.editorTarget.value
    this.previewFormTarget.requestSubmit()
  }
}
