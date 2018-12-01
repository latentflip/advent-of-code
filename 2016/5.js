const crypto = require('crypto');
const cipher = crypto.createHash('md5');

let idx = 0;
let pwd = 'wtnhxymk';
let result = '';

while (true) {
  const cipher = crypto.createHash('md5');
  const test = '' + pwd + idx;
  const hash = cipher.update(test).digest('hex');
  if (hash.match(/^00000/)) {
    result += hash[5]
    console.log(test, result);
  }

  if (result.length === 8) {
    break;
  }

  if (idx % 1000000 === 0) {
    console.log(idx);
  }

  idx++;
};

console.log(result);
