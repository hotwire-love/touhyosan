import { Controller } from "@hotwired/stimulus";
import autosize from "autosize/dist/autosize.esm";

export default class extends Controller {
  connect() {
    console.log("Connected to textarea_autosize_controller");
    this.say();
    autosize(this.element);
  }
  say() {
    console.log("say() in textarea_autosize_controller");
  }
  submitx() {
    console.log("submitx() in textarea_autosize_controller");
  }
  submit() {
    console.log("Call requestSubmt() in textarea_autosize_controller#submit()");
    this.element.requestSubmit();
  }

  disconnect() {
    autosize.destroy(this.element);
  }
}
