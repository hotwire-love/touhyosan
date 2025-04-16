import { Controller } from "@hotwired/stimulus"
import { marked } from "marked";

// Connects to data-controller="markdown"
export default class extends Controller {
  static targets = ["editor", "preview"]

  connect() {
    this.change()
  }

  change() {
    this.previewTarget.innerHTML = marked.parse(this.editorTarget.value);
  }
}
