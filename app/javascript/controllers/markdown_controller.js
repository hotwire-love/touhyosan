import { Controller } from "@hotwired/stimulus"
import { marked } from "marked";
import DOMPurify from 'dompurify';

// Connects to data-controller="markdown"
export default class extends Controller {
  static targets = ["editor", "preview", "previewSwitch"]
  static values = {
    source: String
  }

  connect() {
    if (this.hasEditorTarget) {
      this.change()
      this.togglePreview()
    } else {
      this.show()
    }
  }

  change() {
    this.#renderPreview(this.editorTarget.value)
  }

  show() {
    this.#renderPreview(this.sourceValue)
  }

  togglePreview() {
    this.editorTarget.classList.toggle("d-none", this.previewSwitchTarget.checked);
    this.previewTarget.classList.toggle("d-none", !this.previewSwitchTarget.checked);
  }

  #renderPreview(source) {
    this.previewTarget.innerHTML = DOMPurify.sanitize(marked.parse(source));
  }
}
