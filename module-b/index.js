let c = require('module-c');
let Walker = require('walker');
let w = Walker('./');

module.exports = function run(cb) {
  w.on('end', () => {
    console.log('module-b async end at', c.now);
    cb();
  });
}
