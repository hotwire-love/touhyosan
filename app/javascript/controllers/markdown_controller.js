import { Controller } from "@hotwired/stimulus"
import { marked } from "marked";
import DOMPurify from 'dompurify';

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
    this.previewTarget.innerHTML = DOMPurify.sanitize(marked.parse(this.editorTarget.value));
  }

  show() {
    this.previewTarget.innerHTML = DOMPurify.sanitize(marked.parse(this.sourceValue));
  }
}
