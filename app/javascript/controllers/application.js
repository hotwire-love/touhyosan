import { Application } from "@hotwired/stimulus";
// application.js
import * as Turbo from "@hotwired/turbo";

import TurboPower from "turbo_power";
TurboPower.initialize(Turbo.StreamActions);

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
