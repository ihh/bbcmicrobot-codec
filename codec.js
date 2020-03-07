#!/usr/bin/env node

const fs = require('fs'),
      path = require('path'),
      Getopt = require('node-getopt'),
      dasmReq = require('dasm'),
      dasm = dasmReq.default,
      resolveIncludes = dasmReq.resolveIncludes

const defaultAddrHex = 'c21'

let getopt = Getopt.create([
    ['s' , 'source=FILE'  , 'specify 6502 source file'],
    ['c' , 'code=TEXT'    , 'specify 6502 from command line'],
    ['a' , 'address=HEX'  , 'specify start address for compilation in hexadecimal (defaults to ' + defaultAddrHex + ')'],
    ['x' , 'exec=SYMBOL'  , 'symbol for start of execution (defaults to START, or --address)'],
    ['e' , 'end=SYMBOL'   , 'symbol for end of base64-encoding, e.g. start of plain ASCII data (default is CHARS)'],
    ['p' , 'prefix=BASIC' , 'BASIC code to run before poking/decoding (default is BASIC_PREFIX symbol)'],
    ['i' , 'init=BASIC'   , 'BASIC code to run before executing (default is BASIC_INIT symbol)'],
    ['d' , 'dump'         , 'dump all code, symbols, and data for debugging'],
    ['u' , 'unspam'       , 'bypass spam filter by avoiding Twitter @username tags'],
    ['v' , 'verbose=N'    , 'passed to assembler'],
    ['h' , 'help'         , 'display this help message']
])              // create Getopt instance
.bindHelp()     // bind option 'help' to default action
const opt = getopt.parseSystem() // parse command line

let source = opt.options.source || (opt.options.code ? null : opt.argv[0])
if (!opt.options.code && !source)
  throw new Error ("Please specify a 6502 source file with --source, or code on the command line with --code")
if (opt.options.code && source)
  throw new Error ("You can't specify both --code and --source")
const rawSrc = opt.options.code ? opt.options.code.split(';').map((l)=>"\t"+l+"\n").join('') : fs.readFileSync (source)

const addrHex = opt.options.address || defaultAddrHex
const src = "\tprocessor 6502\n\torg $" + addrHex + "\n" + rawSrc

const addr = eval ('0x' + addrHex)
if (addr % 3)
  throw new Error ("Start address (" + addr.toString(16) + ") is not a multiple of 3. Try tweaking --address")

function resolveIncludesFromFileSystem(baseDir) {
	return (uri, isBinary) => {
		const fullUri = path.join(__dirname, baseDir, uri);
		if (fs.existsSync(fullUri)) {
			if (isBinary) {
				return bufferToArray(fs.readFileSync(fullUri));
			} else {
				return fs.readFileSync(fullUri, "utf8");
			}
		}
	};
}

function bufferToArray(b) {
    const arr = new Uint8Array(b.length);
    return arr.map((v, i) => b[i]);
}

const includes = resolveIncludes (src, resolveIncludesFromFileSystem (source ? path.dirname(source) : '.'))

let opts = { parameters: '', includes }
if (opt.options.verbose)
  opts.parameters += '-v' + opt.options.verbose

if (opt.options.dump)
  console.warn (JSON.stringify ({ src, opts }))

const asmResult = dasm (src, opts)
console.warn (asmResult.output.join("\n"))

const errors = asmResult.list.filter ((l) => l.errorMessage).map ((l) => l.errorMessage)
if (errors.length)
  console.error (errors.join("\n"))

let allData = []
for (let i = 2; i < Object.keys(asmResult.data).length; ++i)
  allData.push (asmResult.data[i])

let symbols = {}
asmResult.symbols.forEach ((sym) => { symbols[sym.name] = sym.value })
asmResult.symbolsRaw.split("\n").slice(1).forEach ((line) => {
  const fields = line.split(/\s+/);
  if (fields[2] == 'str') {
    symbols[fields[0]] = fields[3].replace(/^"/,'').replace(/"$/,'')
  }
})

const endAddr = (opt.options.end
                 ? symbols[opt.options.end]
                 : (symbols.CHARS
                    ? symbols.CHARS
                    : (addr + allData.length)))
const binaryLen = endAddr - addr
const ascData = allData.slice (binaryLen), binData = allData.slice (0, binaryLen)

const toHex = (n) => { let h = n.toString(16); while (h.length < 2) h = '0' + h; return h };
if (opt.options.dump) {
//  console.warn ("Result: " + JSON.stringify(asmResult))
  console.warn ("Data: " + allData.map(toHex).join(' '))
  console.warn ("Symbols: " + JSON.stringify (symbols))
}

let l = [], lcur = 0
binData.forEach ((x, i) => {
  const b = 2 * (i % 3);
  lcur += (x & 3) << b;
  if (b == 4) {
    l.push (lcur);
    lcur = 0;
  }
});
l.push (lcur);

const encodedAddr = addr - l.length
const offsetAddr = encodedAddr - (addr / 3)
const lastAddr = endAddr - 1
const execAddr = (opt.options.exec
                  ? symbols[opt.options.exec]
                  : (symbols.START
                     ? symbols.START
                     : addr))

const encode = (x) => ((x == 63 || x == 32) ? x : (x + 64));

const r = binData.map ((x, i) =>
		       (((x - (encode(l[Math.floor(i/3)]) >> (2*(i % 3)))) & 0xff) >> 2));

const lr = l.concat(r);
const encoded = lr.map(encode).concat(ascData);

let encodedStr = encoded.map (x => String.fromCharCode(x)).join('');
if (opt.options.unspam) {
  let old;
  do {
    old = encodedStr
    encodedStr = encodedStr.replace (/@([a-zA-Z0-9]{1,15}[^a-zA-Z0-9])/g, (_m, g) => '@"+"' + g);
  } while (encodedStr !== old)
}

const decoded = r.map ((e, i) => ((encode(e)*4 + (encoded[Math.floor(i/3)] >> (2*(i % 3)))) & 0xff)).concat (ascData);

if (decoded.filter ((d, i) => allData[i] != d).length) {
  console.warn ("        l: " + JSON.stringify(l));
  console.warn ("l.encoded: " + JSON.stringify(l.map(encode)));
  console.warn ("        r: " + JSON.stringify(r));
  console.warn ("     data: " + JSON.stringify(data));
  console.warn ("  decoded: " + JSON.stringify(decoded));
  throw new Error ("Test decoding failed");
}

const prefix = "@bbcmicrobot ";
const maxTweetLen = 280;

const basicPrefix = (opt.options.prefix
                     ? (opt.options.prefix + "\n")
                     : (symbols.BASIC_PREFIX
                        ? (symbols.BASIC_PREFIX + "\n")
                        : ''));

const basicInit = (opt.options.init
                   ? (opt.options.init + ":")
                   : (symbols.BASIC_INIT
                      ? (symbols.BASIC_INIT + ":")
                      : ''));

const basic = basicPrefix + '$' + encodedAddr + '="' + encodedStr + '"' + "\nF.I=" + addr + 'TO' + lastAddr + ':?I=?I*4+(?(' + offsetAddr + "+I/3)/4^(I MOD3)):N.\n" + basicInit + "CA." + execAddr;

const over = prefix.length + basic.length - maxTweetLen;

console.warn ("(" + basic.length + " bytes; " + (over > 0 ? (over + " over") : (-over + " spare")) + ")")
console.log (basic)
