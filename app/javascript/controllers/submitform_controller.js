import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="submitform"
export default class extends Controller {
  connect() {}
  submit() {
    console.log("submit in submitform_controller");
    this.element.requestSubmit();
  }
  no_action() {}
}
