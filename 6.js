const loadData = require('./load-data')

var testData = `
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
`;
  
const data = loadData('6.src', testData, { splitAndTrim: true, useTest: !true });

const values = (obj) => Object.keys(obj).map((k) => obj[k]);

const ranks = data.reduce((ranks, line) => {
  line.trim().split('').forEach((char, i) => {
    ranks[i] = ranks[i] || {};
    ranks[i][char] = ranks[i][char] || { char, count: 0 };
    ranks[i][char].count++;
  });
  return ranks;
}, []);


// part 1
const chars = ranks.map((rankMap) => {
  return values(rankMap).sort((a,b) => a.count > b.count ? -1 : 1)[0].char
});

// part 2
const chars = ranks.map((rankMap) => {
  return values(rankMap).sort((a,b) => a.count > b.count ? 1 : -1)[0].char
});

console.log(chars.join(''));
