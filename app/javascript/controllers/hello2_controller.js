import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="hello2"
export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element);
  }
  say() {
    console.log("Say!!");
  }
  get() {
    console.log("Say!!");
  }
}
