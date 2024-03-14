import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="submitx"
export default class extends Controller {
  connect() {
    console.log("Connected to submitx_controller");
  }
  submitx() {
    console.log("submit in submitx_controller");
    this.element.requestSubmit();
  }
  no_action() {}

  disconnect() {
    console.log("Disconnected from submitx_controller");
  }
}

