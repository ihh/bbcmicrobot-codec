# bbcmicrobot-codec

Uses Eben Upton's [base64-encoding](https://twitter.com/EbenUpton/status/1230646662680412162)
and the [dasm](https://www.npmjs.com/package/dasm) assembler
to assemble 6502 and encode it into a BASIC-wrapped tweet
for Dominic Pajak's [@bbcmicrobot](https://twitter.com/bbcmicrobot).

Installation:

~~~~
npm install dasm node-getopt
~~~~

Example usage:

~~~~
./codec.js test.asm
~~~~
