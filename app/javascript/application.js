// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";
import "./notification";

// application.js
import * as Turbo from '@hotwired/turbo'

import TurboPower from 'turbo_power'
TurboPower.initialize(Turbo.StreamActions)

