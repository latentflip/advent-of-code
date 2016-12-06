const crypto = require('crypto');
const cipher = crypto.createHash('md5');

let idx = 0;
let pwd = 'wtnhxymk';
//pwd = 'abc';
let result = '________'.split('');
let found = 0;

while (true) {
  const cipher = crypto.createHash('md5');
  const test = '' + pwd + idx;
  const hash = cipher.update(test).digest('hex');
  if (hash.match(/^00000/)) {
    const position = Number(hash[5]);
    const char = hash[6];

    if (Number.isNaN(position) || position >= 8) {
      idx++;
      continue;
    }

    if (result[position] !== '_') {
      console.log('Skipping duplicate?', position, char, result);
      idx++;
      continue;
    }

    result[position] = char;
    found++;
    console.log(position, char, result.join(''));
  }

  if (found === 8) {
    break;
  }

  if (idx % 5000000 === 0) {
    console.log(idx);
  }

  idx++;
};

console.log(result.join(''));
