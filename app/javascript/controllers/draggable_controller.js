import { Controller } from "@hotwired/stimulus"
import { Sortable } from '@shopify/draggable'

// Connects to data-controller="draggable"
export default class extends Controller {
  connect() {
    const sortable = new Sortable(this.element, {
      draggable: '.StackedListItem--isDraggable',
      mirror: {
        appendTo: this.element,
        constrainDimensions: true,
      },
    });
  }
}
