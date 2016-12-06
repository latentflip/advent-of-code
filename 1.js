const Fs = require('fs');
let src = Fs.readFileSync(`${__dirname}/1.src`).toString();

//src = 'R5, L5, R5, R3';
//src = 'R8, R4, R4, R8';

const steps = src.split(',')
                 .map((step) => step.trim())
                 .map((step) => ({ turn: step[0], distance: parseInt(step.slice(1), 10) }));

const log = (fn) => (...args) => {
  const result = fn(...args);
  console.log(result);
  return result;
};

let lastPosition = {x: 0, y: 0, bearing: 0};
const positionCache = {'0,0': true};
const doubles = [];
const walk = (axis, dist) => {
  const current = Object.assign({}, lastPosition);
  const sign = dist < 0 ? -1 : 1;
  dist = Math.abs(dist);

  while (dist--) {
    current[axis] = current[axis] + sign;
    if (positionCache[`${current.x},${current.y}`]) {
      doubles.push(Object.assign({}, current));
    } else {
      positionCache[`${current.x},${current.y}`] = true;
    }
  }
};
const checkCache = (fn) => (...args) => {
  const result = fn(...args);

  switch (result.bearing) {
    case 0:
    case 180:
      walk('y', result.y - lastPosition.y);
      break;
    case 90:
    case 270:
      walk('x', result.x - lastPosition.x);
      break;
    default:
      throw new Error(`Should never get to bearing of ${bearing}`);
  }

  lastPosition = { x: result.x, y: result.y };
  return result;
};

const position = steps.reduce(checkCache(({ x, y, bearing }, { turn, distance }) => {
  if (turn === 'L') bearing = bearing - 90;
  if (turn === 'R') bearing = bearing + 90;

  bearing = ( 360 + (bearing % 360) ) % 360;

  switch (bearing) {
    case 0:   return { bearing, x,               y: y + distance };
    case 90:  return { bearing, x: x + distance, y };
    case 180: return { bearing, x,               y: y - distance };
    case 270: return { bearing, x: x - distance, y };
    default:
      throw new Error(`Should never get to bearing of ${bearing}`);
  }
}), {x: 0, y: 0, bearing: 0 });

const distance = (position) => Math.abs(position.x + position.y);
console.log(doubles);

console.log(position, distance(position));
console.log(distance(doubles[0]));
