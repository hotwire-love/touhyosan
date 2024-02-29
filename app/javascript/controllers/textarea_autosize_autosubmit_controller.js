import { Controller } from "@hotwired/stimulus"
import autosize from 'autosize/dist/autosize.esm'

// Connects to data-controller="textarea-autosize-autosubmit"
export default class extends Controller {
  connect() {
    autosize(this.element)
  }

  disconnect(){
    autosize.destroy(this.element);
  }

  submit() {
    this.element.requestSubmit()
  }
}
