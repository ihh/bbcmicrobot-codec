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
$3097="HM^cgxx@vGBWOGdzizBzfdIjt~ut~"
F.I=3105TO3125:?I=?I*4+(?(2062+I/3)/4^(I MOD3)):N.
CA.3105
~~~~
Running this (e.g. by pasting it into [jsbeeb](https://bbc.godbolt.org/) or the BBCMicroBot [editor](https://editor.8bitkick.cc/)) should print `**OK**` and return to the BASIC prompt.

Note there are three lines: the first pokes the data, the second does the base64-decoding, and the third runs the code.
You can introduce additional lines of BASIC if you want, e.g. to print text, clear the screen, change [MODE](https://en.wikipedia.org/wiki/BBC_Micro#Display_modes), etc.

### Wright-Fisher model

~~~~
./codec.js wright-fisher.asm --exec INIT
~~~~
This is a simulation of a [Wright-Fisher model](https://twitter.com/ianholmes/status/1235079487634599936?s=20)
(or, more precisely, a Moran model: see the [Genetic Drift](https://en.wikipedia.org/wiki/Genetic_drift) page on Wikipedia for more info).

Note the use of `--exec` to change the start of execution.

The [code](wright-fisher.asm) calls the BBC BASIC RND subroutine at $af87 (documented [here](http://mdfs.net/Info/Comp/Acorn/Source/Basic.htm)), as well as [OSWRCH](http://beebwiki.mdfs.net/OSWRCH) at $ffee.


### Diffusion

~~~~
./codec.js diffusion.asm
~~~~
This implements a simple diffusion, shown in action [here](https://twitter.com/bbcmicrobot/status/1235417667273519104?s=20).

# Spam filter

Unfortunately some of the generated strings don't work when you give them to the bot, because of things in the code that look like Twitter handles (`@...`), which the bot strips out.
You can work around this by specifying the `--unspam` option, which breaks these strings with quotes (at a cost of 3 bytes per case).
