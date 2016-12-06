const loadData = require('./load-data');

const testData = `
aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]
`;

const data = loadData('4.src', testData, { splitAndTrim: true, useTest: false });


const parseRoom = (str) => {
  let [room,checksum] = str.split('[');

  checksum = checksum.slice(0, -1);
  const roomParts = room.split('-');

  const sectorId = roomParts[roomParts.length - 1];
  room = roomParts.slice(0, -1).join('');

  return {
    original: str, room, sectorId, checksum
  };
};

const charToIndex = (char) => char.toLowerCase().charCodeAt(0) - 97;

const roomIsValid = (room) => {
  const charCounts = [];

  const increment = (char) => {
    const idx = charToIndex(char);
    if (charCounts[idx]) {
      charCounts[idx].count++;
    } else {
      charCounts[idx] = { char, count: 1 };
    }
  };

  room.room.split('').forEach(increment);

  const sortedCounts = charCounts.sort((a,b) => a.count < b.count ? 1 : -1);

  const checksum = charCounts.sort((a,b) => {
    if (a.count > b.count) return -1;
    if (a.count < b.count) return 1;

    return a.char.charCodeAt(0) < b.char.charCodeAt(0) ? -1 : 1;
  }).slice(0,5).map((c) => c.char).join('');

  console.log(room.original, checksum, checksum === room.checksum, checksum.split('').sort().join('') === room.checksum.split('').sort().join(''));
  return checksum === room.checksum;
};


const rooms = data.map(parseRoom);
console.log(data);
console.log(rooms);

console.log(rooms.filter(roomIsValid).reduce((sum,r) => sum += Number(r.sectorId), 0));
