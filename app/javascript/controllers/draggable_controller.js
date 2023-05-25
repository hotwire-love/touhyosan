import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs'

// Connects to data-controller="draggable"
export default class extends Controller {
  static targets = ['position'];

  connect() {
    const sortable = new Sortable(this.element, {
      draggable: '.StackedListItem--isDraggable',
      onUpdate: this.onStop.bind(this),
    });
  }

  onStop() {
    this.positionTargets.forEach((element, index) => {
      element.value = index
    })

    this.dispatch('sorted')
  }
}
