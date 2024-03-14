import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ytest"
export default class extends Controller {
  connect() {
    console.log("Connected to ytest_controller");
  }
  say() {
    console.log("say in ytest_controller");
  }
}
