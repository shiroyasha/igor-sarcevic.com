compilePartials = require('./config/compilePartials')

module.exports = (grunt) ->

  settings = {
    sourceFolder: 'src'
    outputFolder: 'out'

    scriptsFolder: 'script'
    vendorFolder: 'vendor'
    styleFolder: 'style'

    imageFolder: 'img'
  }

  selectFiles = ( srcFiles, extension, options ) ->
    {
      expand: true
      cwd: settings.sourceFolder
      src: srcFiles
      dest: settings.outputFolder
      ext: extension

      options: options
    }


  # Project configuration.
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json')


    # coffee compiler
    coffee: 
      compile: selectFiles(['**/*.coffee'], '.js', {
        bare: true
      })

    # stylus compiler
    stylus: {
      use: [
        require('axis-css')
      ]
    })

    # markdown compiler
    markdown: rules1(['**/*.partial.md'], '.partial', {
      template: 'config/template.html'
    })


    copy:
      cycle1:
        expand: true
        cwd: settings.sourceFolder
        src: ["**/*", '!**/*.js.coffee', '!**/*.css.styl', '!**/*.partial.md']
        dest: settings.tempFolder

      cycle2:
        expand: true
        cwd: settings.tempFolder
        src: ["**/*", "!style/**/*.css", "!script/**/*.js", "!partials", "!partials/**/*", "!**/*.html", "!vendor/**/*"]
        dest: settings.outputFolder

      cycle3:
        expand: true
        cwd: settings.outputFolder
        src: ["**/*", "!script/**/*" ]
        dest: settings.productionReadyFolder

      cycle4:
        src: settings.sourceFolder + '/vendor/require.js'
        dest: settings.productionReadyFolder + '/vendor/require.js'                


    partial: rules2(['**/*.html'], '.html', {})

    concat:
      styles:
        options:
          separator: "\n"

        src: [ settings.tempFolder + '/style/**/*.css']
        dest: settings.outputFolder + '/style/style.css'

      vendor:
        options:
          separator: "\n"

        src: [ settings.tempFolder + '/vendor/**/*.js', "!" + settings.tempFolder + '/vendor/require.js']
        dest: settings.outputFolder + '/vendor/vendor.js'

    amdwrap:
      compile:
        expand: true,
        cwd: settings.tempFolder
        src: ["script/**/*.js"]
        dest: settings.outputFolder

    clean: [settings.tempFolder, settings.outputFolder, settings.productionReadyFolder]



    requirejs:
      compile:
        options:
          baseUrl: settings.outputFolder + '/script'
          #mainConfigFile: settings.outputFolder + '/script/app.js'
          name: "app"
          out: settings.productionReadyFolder + '/script/app.js'
        



  }



  # Load the plugin that provides the "uglify" task.
  # grunt.loadNpmTasks('grunt-contrib-uglify')

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-markdown')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks("grunt-amd-wrap")
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')

  grunt.registerMultiTask 'partial', 'Compiles partials into html', compilePartials(grunt)


  grunt.loadNpmTasks('grunt-contrib-requirejs')


  # Default task(s).
  grunt.registerTask('default', ['clean', 'copy:cycle1', 'coffee:compile',
    'stylus:compile', 'markdown:compile',  'copy:cycle2', 'partial:compile', 'concat', 'amdwrap' ])


  grunt.registerTask('production', ['default', 'copy:cycle3', 'requirejs', 'copy:cycle4'])