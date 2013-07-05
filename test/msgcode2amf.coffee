# Description 

# Created with Project 
# User  YuanXiangDong
# Date  13-7-5
# To change this template use File | Settings | File Templates.

google_doc = require '../src/main'
fs = require 'fs'
sys = require('sys')
amf = require('../src/node-amf/amf')
utils = require('../src/node-amf/utils')
#var utils = require('./node-amf/utils');

#console.dir amf


tests = [
  ['empty string', ''],
  ['ascii string', 'Hello World'],
  ['unicode string', '£今\u4ECA"\u65E5日'],

  ['zero',  0 ],
  ['integer in 1 byte u29 range', 0x7F ],
  ['integer in 2 byte u29 range', 0x00003FFF ],
  ['integer in 3 byte u29 range', 0x001FFFFF ],
  ['integer in 4 byte u29 range', 0x1FFFFFFF ],
  ['large integer', 4294967296 ],
  ['large negative integer', -4294967296 ],
  ['small negative integer', -1 ],
  ['small floating point', 0.123456789 ],
  ['small negative floating point', -0.987654321 ],
  ['Number.MIN_VALUE', Number.MIN_VALUE ],
  ['Number.MAX_VALUE',  Number.MAX_VALUE ],
  ['Number.NaN', Number.NaN],

  ['Boolean false', false],
  ['Boolean true', true ],
  ['undefined', undefined ],
  ['null', null],

  ['empty array', [] ],
  ['sparse array', [undefined,undefined,undefined,undefined,undefined,undefined] ],
  ['multi-dimensional array',  [[[],[]],[],] ],

  ['date object (epoch)', new Date(0) ],
  ['date object (now)', new Date() ],

  ['empty object', {} ],
  ['keyed object', { foo:'bar', 'foo bar':'baz' } ],
  ['refs object', { foo: _ = { a: 12 }, bar: _ } ]
]

toAmf = () ->
  console.log('Serializing and deserializing '+tests.length+' test values')
  n = 0
  for t in [0...tests.length]
    try
      descr = tests[t][0]
      value = tests[t][1]
      s = sys.inspect(value).replace(/\n/g,' ')
      sys.puts( ' > ' +descr+ ': ' + s)
      amf.serializer().writeValue( value )
      Ser = amf.serializer()
      bin = Ser.writeValue( value )
      Des = amf.deserializer( bin )
      value2 = Des.readValue( amf.AMF3 )
      sys.puts(' < '+descr+": "+ value2)
      s2 =  sys.inspect(value2).replace(/\n/g,' ')

      unless typeof value2 == typeof value
        throw new Error('deserialized value of wrong type; ' + s2)
      unless s == s2
        throw new Error('deserialized value does not match; ' + s2)
      sys.puts('   OK')
      n++
    catch Er
      sys.puts('**FAIL** ' + Er.message )

  sys.puts('Tests '+n+'/'+tests.length+' successful\n');

toAmfPackage = () ->
  try
    Packet = amf.packet()

#    Packet.addHeader( 'header 1', 'Example header 1' )
#    Packet.addHeader( 'header 2', 'Example header 2' )

#    requestURI = '/1/onResult'
#    responseURI = '/1'

    n = 0
    for t in [0...tests.length]
      struct = {}
      descr = tests[t][0]
      value = tests[t][1]
      struct[descr] = value;
      Packet.addMessage( struct)

    bin = Packet.serialize();
    sys.puts(' > Packet serialization ok')
#    sys.puts( utils.hex( bin ) )
    buffer = new Buffer(bin)
    fs.writeFile("./msgcode.sgf", buffer, (err) ->
      if err?
        console.error "error: "+err.message
    )
    return bin
  catch Er
    sys.puts('***FAIL*** error serializing packet: ' + Er.message )
    return ''
  return ''

deseAmf = (bin) ->
  try
    Packet = amf.packet( bin )
    sys.puts(' > Packet deserialization ok')
    sys.puts( sys.inspect(Packet) )
    messages = Packet.messages
    for i, value of messages
#      console.log i+" - "+value.value
      console.dir value.value
  catch Er
    sys.puts('***FAIL*** error deserializing packet: ' + Er.message )
    return

back = (data) ->
#  console.log data
  lines = data.split('\n')
  msgcodes = []
  for line in lines
#    console.log  " - "+line
    arr=line.split(',')
    if arr and arr.length>0 and arr[0] and arr[1]

      name=arr[0].replace(/^\s+|\s+$/g, "")
      codeStr=arr[1].replace(/^\s+|\s+$/g, "")
#      name = Number(name)
      msgcodes.push [name,codeStr]
#      msgcode+="  #{name}:#{codeStr}\n"

#  console.dir msgcodes
  tests = msgcodes
  deseAmf(toAmfPackage())
  return msgcodes


#  console.dir datas
#  fs.writeFile("./msgcode.csv", data.toString('utf-8'), (err) ->
#    if err?
#      console.error "error: "+err.message
#  )

do ->
#  toAmf()
#  deseAmf(toAmfPackage())

  option = {
    host:'192.168.90.241'
    port:'8088'
    method:'GET'
    path:''
  }

  google_doc.init(option,back).start()


###   AS3 读取amf后得到的是一个byteArray类型。
      var object:Object = {a:1, b:"2", c:[3,4], d:5.53};
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);

			var s:String = byteArray.toString();

			byteArray = new ByteArray();
			byteArray.writeMultiByte(s, s);

			byteArray.position = 0;
			trace(byteArray.readObject().a);
###