import 'dart:convert';

const BrailleToChar = <String, String>{
  '100000': 'A',
  '110000': 'B',
  '100100': 'C',
  '100110': 'D',
  '100010': 'E',
  '110100': 'F',
  '110110': 'G',
  '110010': 'H',
  '010100': 'I',
  '010110': 'J',
  '101000': 'K',
  '111000': 'L',
  '101100': 'M',
  '101110': 'N',
  '101010': 'O',
  '111100': 'P',
  '111110': 'Q',
  '111010': 'R',
  '011100': 'S',
  '011110': 'T',
  '101001': 'U',
  '111001': 'V',
  '010111': 'W',
  '101101': 'X',
  '101111': 'Y',
  '101011': 'Z',
  '001111': '#',
  '001000': ' '
};

List<int> charToBraille(String c) {
  c = c.toUpperCase();

  try {
    final indexOfChar = utf8.encode(c)[0] - utf8.encode('A')[0];
    final braille = BrailleToChar.keys.elementAt(indexOfChar);

    final bits = braille.split('').map((e) => int.parse(e)).toList();
    return bits;
  }
  on RangeError {

  }
  catch (e) {
    print('Braille encoding error $e');
  }

  // return space
  return <int>[0, 0, 1, 0, 0, 0];
}