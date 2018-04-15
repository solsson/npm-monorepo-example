let once = require('once');
let datehex = require('./');
let get = once(() => datehex);
if (!get().now) throw new Error('Failed to run datehex module');
