import { Controller } from "@hotwired/stimulus"
import { Sortable } from '@shopify/draggable'

// Connects to data-controller="draggable"
export default class extends Controller {
  static targets = ['position'];

  connect() {
    const sortable = new Sortable(this.element, {
      draggable: '.StackedListItem--isDraggable',
      mirror: {
        appendTo: this.element,
        constrainDimensions: true,
      },
    });

    sortable.on('sortable:stop', this.onStop.bind(this));
  }

  onStop(e) {
    console.log(e)
    // TODO: DOMが確定する前にイベントが発生するため一時的にsetTimeoutしてる
    setTimeout(() => {
      this.positionTargets.forEach((element, index) => {
        element.value = index
      })
    }, 0)
  }
}
