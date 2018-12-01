const loadData = require('./load-data');

const testData = `
qzmt-zixmtkozy-ivhz-343[zimth]
`;

const data = loadData('4.src', testData, { splitAndTrim: true, useTest: false });


const parseRoom = (str) => {
  let [room,checksum] = str.split('[');

  checksum = checksum.slice(0, -1);
  const roomParts = room.split('-');

  const sectorId = Number(roomParts[roomParts.length - 1]);
  room = roomParts.slice(0, -1).join('');

  return {
    original: str, room, sectorId, checksum, encrypted: roomParts.slice(0, -1).join('-')
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

  return checksum === room.checksum;
};

const shiftChar = (char, shift) => String.fromCharCode((((char.charCodeAt(0) - 97) + shift) % 26) + 97);

const decryptRoom = (room) => {
  const shift = room.sectorId % 26;
  const decrypted = room.encrypted.split('').map((c) => {
    if (c === '-') return ' ';
    return shiftChar(c, shift);
  }).join('');

  return decrypted;
};


const rooms = data.map(parseRoom);
//console.log(data);
//console.log(rooms);

//console.log(rooms.filter(roomIsValid).reduce((sum,r) => sum += r.sectorId), 0);

console.log(rooms.filter(roomIsValid).filter((room) => decryptRoom(room).match(/north/)))

//console.log(decryptRoom({ sectorId: 1, encrypted: 'a-b-c' }));
