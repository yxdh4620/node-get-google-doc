###
# 一个读取google doc 的工具类
###

# Created with Project 
# User  YuanXiangDong
# Date  13-7-5
# To change this template use File | Settings | File Templates.

## import modules start.
logger = require 'logger'
fs = require 'fs'
http = require 'http'

## import modules end.

options = {
  host:''
  port:''
  method:'GET'
  path: ''
}

module.exports =

  init : (option, callback) ->
    if option?
      logger.info "[get-google-doc:main:init:28]: init options"
      options['host'] = option['host'] if option['host'] and option['host'].trim().length>0
      options['port'] = option['port'] if option['port'] and option['port'].trim().length>0
      options['method'] = option['method'] if option['method'] and option['method'].trim().length>0
      options['path'] = option['path'] if option['path'] and option['path'].trim().length>0
#    console.dir options
    logger.info "[get-google-doc:main:init:34]: options:#{options.toString()}"

    start : () ->
      data = ''
      req = http.get(options, (res) ->
        logger.info("[get-google-doc:main:init:34]:statusCode: ", res.statusCode)
        res.on('data', (d) ->
          data += d.toString()
        ).on('end',()->
          if callback? and typeof callback 'function'
            callback data
          else
            module.exports.callbacks data
        )
      ).on('error',(e)->
        logger.error "[get-google-doc:main:init:http.get]:error: "+ e.message
      )
#      req.end()
#      if callback? and typeof callback 'function'
#        callback data
#      else
#        module.exports.callbacks data

  callbacks : (data) ->
    fs.writeFile("../lib/msgcode.txt", data.toString(), (err)->
      if err?
        logger.error "[get-google-doc:main:callbacks]:error: "+err.message
    )

#do ->
#  option = {
#    host:'192.168.90.241'
#    port:'8088'
#    method:'GET'
#    path:'https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE&single=true&gid=0&range=B2%3AC9999&output=txt'
#  }
#
#  module.exports.init(option).start()
#  back = (data) ->
#    fs.writeFile("./msgcode.csv", data.toString('utf-8'), (err) ->
#      if err?
#        console.error "error: "+err.message
#    )
#  option = {
#    host:'192.168.90.241'
#    port:'8088'
#    method:'GET'
##    path:'https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE&single=true&gid=0&range=B2%3AC9999&output=csv'
#    path:'https://docs.google.com/spreadsheet/pub?key=0Ap0bfNc2zisXdDlOUmxYRUpDRXR5bmdRckJKMWtuSUE\&single=true\&gid=0\&range=A2%3AB3000\&output=csv'
#  }
#
#  module.exports.init(option,back).start()
