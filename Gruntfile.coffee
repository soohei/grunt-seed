module.exports = (grunt) ->
  # Load grunt tasks automatically
  require('load-grunt-tasks')(grunt)

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # load package.json
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    ###################################
    # compile

    compass:
      default:
        options:
          config: 'source/styles/config/config.rb'

    coffee:
      options:
        sourceMap: true
      default:
        expand: true
        cwd:    'source/scripts/'
        src:    '**/*.coffee'
        dest:   '.tmp/scripts/'
        ext:    '.js'


    ###################################
    # clean, copy

    clean:
      default:  [ '.tmp', 'assets' ]
      dist:     [ 'assets/**/*.css.map', 'assets/**/*.js.map' ]

    copy:
      css:
        files: [
          expand: true
          cwd:    'source'
          src:    ['styles/**/*.css']
          dest:   '.tmp'
        ]
      js:
        files: [
          expand: true
          cwd:    'source'
          src:    [ 'scripts/**/*.js' ]
          dest:   '.tmp'
        ]
      webfonts:
        files: [
          expand: true
          cwd:    'source/webfonts'
          src:    ['*.{eot,svg,ttf,woff,js}']
          dest:   'assets/styles'
        ]
      static:
        files: [
          expand: true
          cwd:    'source'
          src:    [ 'images/**/*' ]
          dest:   'assets'
        ]


    ###################################
    # uglify, concat

    uglify:
      options:
        drop_console: true
      vendor:
        options:
          preserveComments: 'some'
        files:
          'assets/scripts/vendor.js': [
            'source/libs/console-safer.js'
            'source/bower_components/respond/dest/respond.min.js'
            'source/bower_components/modernizr/modernizr.js'
            'source/bower_components/css_browser_selector/css_browser_selector.min.js'
            'source/bower_components/jquery/dist/jquery.min.js'
            'source/bower_components/bootstrap/dist/js/bootstrap.min.js'
          ]
      dist:
        files:
          'assets/scripts/main.js': [
            '.tmp/scripts/**/*.js'
          ]

    cssmin:
      vendor:
        options:
          preserveComments: 'some'
        files:
          'assets/styles/vendor.css': [
            'source/bower_components/bootstrap/dist/css/bootstrap.min.css'
          ]
      dist:
        files:
          'assets/styles/styles.css': [
            '.tmp/styles/**/*.css'
          ]

    concat:
      options:
        sourceMap: true
      vendor_js:
        files: '<%= uglify.vendor.files %>'
      js:
        files: '<%= uglify.dist.files %>'
      vendor_css:
        files: '<%= cssmin.vendor.files %>'
      css:
        files: '<%= cssmin.dist.files %>'

    svgmin:
      options:
        plugins: [
          {
            removeViewBox: false
          }
          {
            removeUselessStrokeAndFill: false
          }
        ]
      dist:
        files: [
          expand: true
          cwd:    'source/svg'
          src:    [ '**/*.svg' ]
          dest:   'source/svg_min'
        ]


    ###################################
    # finalize

    autoprefixer:
      options:
        map: true
        browsers: ['last 2 version', 'ie 8', 'ie 9']
      default:
        expand: true
        cwd:    'assets/styles'
        src:    '**/*.css'
        dest:   'assets/styles'

    cmq:
      default: '<%= autoprefixer.default %>'

    csscomb:
      default: '<%= autoprefixer.default %>'

    csso:
      default: '<%= autoprefixer.default %>'

    cachebreaker:
      dev:
        options:
          match: [
            './assets/scripts/main.js'
            './assets/scripts/vendor.js'
            './assets/styles/vendor.css'
            './assets/styles/styles.css'
          ]
        files:
          src: ['index.html']


    ###################################
    # watch

    watch:
      css:
        files: 'source/styles/**/*.css'
        tasks: ['newer:copy:css', 'concat:css']

      scss:
        files: 'source/styles/**/*.scss'
        tasks: ['compass', 'concat:css', 'autoprefixer']

      vendor:
        files: ['source/bower_components/**/*.{css,js}', 'Gruntfile.coffee']
        tasks: ['concat:vendor_css', 'autoprefixer', 'concat:vendor_js']

      js:
        files: 'source/scripts/**/*.js'
        tasks: ['newer:copy:js', 'concat:js']

      coffee:
        files: ['source/scripts/**/*.coffee']
        tasks: ['newer:coffee', 'concat:js']

      svg:
        files: ['source/svg/**/*.svg']
        tasks: ['newer:svgmin', 'compass', 'concat:css', 'autoprefixer']

      webfonts:
        files: ['source/webfonts/*.{eot,svg,ttf,woff,js}']
        tasks: ['newer:copy:webfonts']

      static:
        files: ['source/images/**/*']
        tasks: ['newer:copy:static']


    ###################################
    #  connect
    ###################################

    browserSync:
      bsFiles:
        src : [
          '**/*.html'
          '**/*.php'
          'images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
          'assets/scripts/**/*.js'
          'assets/styles/**/*.css'
        ]

      options:
        watchTask: true
        server:
          baseDir: "./"


  ###################################
  #
  # tasks
  #
  ###################################

  # defalt
  grunt.registerTask 'default', [
                                  # clean
                                  'clean'
                                  'copy:webfonts'
                                  'copy:static'
                                  # styles
                                  'svgmin'
                                  'compass'
                                  'copy:css'
                                  'concat:vendor_css'
                                  'concat:css'
                                  'autoprefixer'
                                  # scripts
                                  'coffee'
                                  'copy:js'
                                  'concat:vendor_js'
                                  'concat:js'
                                  # watch
                                  'browserSync'
                                  'watch'
                                ]

  # distribution
  grunt.registerTask 'dist', [
                                # clean
                                'clean'
                                'copy:webfonts'
                                'copy:static'
                                # styles
                                'svgmin'
                                'compass'
                                'copy:css'
                                'cssmin:vendor'
                                'cssmin:dist'
                                'autoprefixer'
                                # scripts
                                'coffee'
                                'copy:js'
                                'uglify:vendor'
                                'uglify:dist'
                                # finalize
                                # 'cmq'
                                # 'csscomb'
                                'csso'
                                'clean:dist'
                                'cachebreaker'
                              ]

  return

################################
# References:
# https://www.allantatter.com/wordpress-theme-development-grunt-js/
