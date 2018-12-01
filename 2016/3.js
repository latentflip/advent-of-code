const Fs = require('fs');

let src = `
  1 2 4
  2 3 5
  3 4 5
`;

src = Fs.readFileSync(__dirname + '/3.src').toString();



// triangles for part 1
const triangles = src.trim().split('\n').map((l) => {
  return (
    l.trim()
      .split(' ')
      .filter((n) => n.trim())
      .map(Number)
      .sort()
  );
});


// triangles for part 2
const triangles2 = [];
let currentTriangles = [[],[],[]];

const pushNumbers = (a,b,c) => {
  currentTriangles[0].push(a);
  currentTriangles[1].push(b);
  currentTriangles[2].push(c);

  if (currentTriangles[0].length === 3) {
    triangles2.push(...currentTriangles);
    currentTriangles = [[],[],[]];
  }
};

src.trim().split('\n').forEach((l) => {
  const ns = l.trim()
              .split(' ')
              .filter((n) => n.trim())
              .map(Number);
  pushNumbers(...ns);
});



const numericSort = (a,b) => (a > b ? 1 : -1);
const isTriangle = (sides) => {
  sides = sides.sort(numericSort);

  return sides[0] + sides[1] > sides[2];
};

const valid = triangles.filter(isTriangle)
const valid2 = triangles2.filter(isTriangle)

//console.log(triangles.slice(0,10));
//console.log(valid.length);

console.log(triangles2.slice(0,10));
console.log(valid2.length);
