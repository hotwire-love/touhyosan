import { Controller } from "@hotwired/stimulus"
import { marked } from "marked";

// Connects to data-controller="markdown"
export default class extends Controller {
  static targets = ["preview"]

  connect() {
  }

  change(event) {
    const target = event.target;
    this.previewTarget.innerHTML = marked.parse(target.value);
  }
}
