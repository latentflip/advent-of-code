const Fs = require('fs');
let cmds = Fs.readFileSync('./2.src').toString();

//cmds = `
//ULL
//RRDDD
//LURDL
//UUUUD
//`

cmds = cmds.trim();

const btns = cmds.split('\n').map((l) => l.trim().split(''));

console.log(btns);

const keypad = [
  [false,false,1,false,false],
  [false,2,3,4,false],
  [5,6,7,8,9],
  [false,'A','B','C',false],
  [false,false,'D',false,false]
];

const exists = (coords) => {
  if (!keypad[coords[1]]) return false;
  return !!keypad[coords[1]][coords[0]];
};

const actions = {
  U: (current) => {
    const next = [current[0], current[1] - 1];
    return exists(next) ? next : current;
  },

  D: (current) => {
    const next = [current[0], current[1] + 1];
    return exists(next) ? next : current;
  },

  L: (current) => {
    const next = [current[0] - 1, current[1]];
    return exists(next) ? next : current;
  },

  R: (current) => {
    const next = [current[0] + 1, current[1]];
    return exists(next) ? next : current;
  }
};

const start = [0,2];
let current = start;

for (const steps of btns) {
  for (const action of steps) {
    current = actions[action](current);
  }
  console.log(keypad[current[1]][current[0]]);
}
