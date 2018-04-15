let sha = require('sha.js');
let now = new Date().toISOString();
let hex = sha('sha1').update(now).digest('hex');

module.exports = { now, hex };
console.log('module-c', module.exports);
