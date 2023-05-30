import { Controller } from '@hotwired/stimulus';
import { Modal } from 'bootstrap';

export default class extends Controller {
  static targets = ['modal'];

  connect() {
    this.myModal = new Modal(this.modalTarget);
  }

  disconnect() {
    this.myModal.dispose();
  }

  show() {
    this.myModal.show();
  }

  hide(e) {
    if (e.detail.success && e.detail.formSubmission.submitter) {
      this.myModal.hide();
    }
  }
}
