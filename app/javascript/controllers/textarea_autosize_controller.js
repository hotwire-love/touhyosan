import { Controller } from "@hotwired/stimulus"
import autosize from 'autosize/dist/autosize.esm'

export default class extends Controller {
  connect() {
    autosize(this.element)
  }
}
