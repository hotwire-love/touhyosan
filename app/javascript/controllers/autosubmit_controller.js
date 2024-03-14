import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-submit"
export default class extends Controller {
  submit(event) {
    console.log("submit in autosubmit_controller.js");
    this.element.requestSubmit();
  }
}
