import { Controller } from "@hotwired/stimulus"
import { marked } from "marked";

// Connects to data-controller="markdown"
export default class extends Controller {
  static targets = ["editor", "preview"]
  static values = {
    source: String
  }

  connect() {
    if (this.hasEditorTarget) {
      this.change()
    } else {
      this.show()
    }
  }

  change() {
    this.previewTarget.innerHTML = marked.parse(this.editorTarget.value);
  }

  show() {
    this.previewTarget.innerHTML = marked.parse(this.sourceValue);
  }
}
