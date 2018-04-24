let b = require('./');
let wrappy = require('wrappy');
let happened = false;
b(wrappy(() => {
  happened = true;
}));
setTimeout(() => {
  if (!happened) {
    console.error('Callback did not happen');
    process.exit(1);
  }
}, 100);
