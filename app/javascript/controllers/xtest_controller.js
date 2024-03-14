import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="xtest"
export default class extends Controller {
  connect() {
    console.log("Connected to xtest_controller");
    // this.say();
  }
  say() {
    console.log("say in xtest_controller");
  }
  dat() {
    console.log("dat in xtest_controller");
  }
}
