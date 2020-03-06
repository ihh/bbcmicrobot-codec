# bbcmicrobot-codec

Uses Eben Upton's [base64-encoding](https://twitter.com/EbenUpton/status/1230646662680412162)
and the [dasm](https://www.npmjs.com/package/dasm) assembler
to assemble 6502 and encode it into a BASIC-wrapped tweet
for Dominic Pajak's [@bbcmicrobot](https://twitter.com/bbcmicrobot).

## Installation

~~~~
npm install dasm node-getopt
~~~~

## Example usage

### Test message

~~~~
./codec.js test.asm
~~~~
This should generate the following
~~~~
$3097="HM^cgxx@vGBWOGdzizBzfdIjt~ut~":F.I=3105TO3125:?I=?I*4+(?(2062+I/3)/4^(I MOD3)):N.:CA.3105
~~~~
Running this (e.g. in [jsbeeb](https://bbc.godbolt.org/) or the BBCMicroBot [editor](https://editor.8bitkick.cc/)) should print `**OK**` and return to the BASIC prompt.

### Wright-Fisher model

~~~~
./codec.js wright-fisher.asm --exec INIT
~~~~
This is a simulation of a [Wright-Fisher model](https://twitter.com/ianholmes/status/1235079487634599936?s=20).
Note the use of `--exec` to change the start of execution.

### Diffusion

~~~~
./codec.js diffusion.asm
~~~~
This implements a simple diffusion, shown in action [here](https://twitter.com/bbcmicrobot/status/1235417667273519104?s=20).

# Spam filter

Unfortunately some of the generated strings don't work when you give them to the bot, because of things in the code that look like Twitter handles (`@...`), which the bot strips out.
You can work around this by specifying the `--unspam` option, which breaks these strings with quotes (at a cost of 3 bytes per case).
