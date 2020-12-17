import 'bootstrap-markdown/js/bootstrap-markdown'

import { Controller } from 'stimulus'

export default class extends Controller {
  /*
  Departure from standard StimulusJS usage:

  Bootstrap Markdown assumes a traditional jQuery-based initialization
  on the relevant elements on page load. While we could similarly bind
  this to every page load with Stimulus, for efficiency we only
  initialize on elements contained by the element that connects to this
  controller, when it connects.
  */
  connect() {
    this.init()
  }

  init(event) {
    $(this.element).find('[data-markdown-target="field"]').markdown({autofocus: false})
  }
}
