import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="redirect"
export default class extends Controller {
  static targets = [ "name" ]

  connect() {
    const element = this.nameTarget
    const name = element.value
    const href = element.href
    console.log(`name=${name}`);
    console.log(`href=${href}`);
    // window.location.href = href
    console.log("ABC redirect")
  }
}
