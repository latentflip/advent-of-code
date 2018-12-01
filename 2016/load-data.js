const Fs = require('fs');

module.exports = (name, test, { useTest, splitAndTrim } = {}) => {
  const src = useTest ? test : Fs.readFileSync(__dirname + '/' + name).toString();

  if (splitAndTrim) {
    return src.trim().split('\n').map((l) => l.trim());
  }
};
