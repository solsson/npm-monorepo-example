let c = require('module-c');
let Walker = require('walker');
let w = Walker('./');
let fs = require('fs');

try {
  fs.statSync('./node_modules/once');
  console.error('Seeing a dev dependency from module-c');
  process.exit(1);
} catch(err) {}

module.exports = function run(cb) {
  w.on('end', () => {
    console.log('module-b async end at', c.now);
    cb();
  });
}
