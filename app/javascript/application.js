// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
// application.js
import * as Turbo from "@hotwired/turbo";

import "./controllers";
import * as bootstrap from "bootstrap";
// import "./notification";

// application.js

import TurboPower from "turbo_power";
TurboPower.initialize(Turbo.StreamActions);
