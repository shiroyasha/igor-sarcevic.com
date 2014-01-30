util = require('util')
fs   = require('fs')
path = require('path')


module.exports = (grunt) -> () ->

  regex = /<%(.*?)%>/g

  replaceWithFile = ( inputFile ) -> ( str ) ->
    fileName = str.slice(2, -2).trim() + '.partial'
    filePath = path.join( path.dirname(inputFile.src[0]) , fileName )

    if fs.existsSync( filePath )
      fs.readFileSync( filePath,  {encoding: 'utf8'} )
    else
      grunt.fail.fatal("Can't find partial #{fileName} requested in #{inputFile.src[0]}" )


  for file in this.files
    content = fs.readFileSync( file.src[0],  {encoding: 'utf8'} )
    out = content.replace(regex, replaceWithFile( file ) )

    fs.writeFileSync( file.dest, out, {encoding: 'utf8'} )
    grunt.log.writeln("File \"#{file.dest}\" created.")
