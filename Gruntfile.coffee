module.exports = (grunt) ->
  # load package.json
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    ###################################
    #  build
    ###################################

    compass:
      dist:
        options:
          config: 'source/sass/config/config.rb'
          outputStyle: 'compressed'
          environment: 'production'
      dev:
        options:
          config: 'source/sass/config/config.rb'

    coffee:
      compile:
        options:
          join: true
        files:
          'assets/js/script.js': ['source/coffee/**/*.coffee']


    ###################################
    #  concat
    ###################################

    concat:
      libs_js:
        src: [
          'source/libs/js/**/*.js'
        ]
        dest: 'assets/js/libs.js'

      license_js: {
        src: [
          'assets/js/libs.js'
          'source/libs/license.js'
        ]
        dest: 'assets/js/libs.js'
      }

      license_css: {
        src: [
          'assets/css/style.css'
          'source/libs/license.css'
        ]
        dest: 'assets/css/style.css'
      }

    ###################################
    #  others
    ###################################

    clean: ['assets/css/**/*',
            'assets/js/**/*',
            'assets/img/**/*',
            'assets/sprites/**/*']

    copy: {
      images: {
        files: [
          { expand: true, cwd: 'source/img/', src: ['**'], dest: 'assets/img/' }
        ]
      }
    }

    exec:
      mv_sprite:
        cmd: 'ruby source/sprites/mv_sprite.rb'

    ###################################
    #  release
    ###################################

    autoprefixer:
      options:
        browsers: ['last 2 version', 'ie 8', 'ie 9']
      default:
        src: 'assets/css/style.css'
        dest: 'assets/css/style.css'

    csso:
      default:
        src: 'assets/css/style.css'
        dest: 'assets/css/style.css'

    cmq:
      default:
        src: 'assets/css/style.css'
        dest: 'assets/css/style.css'

    csscomb:
      default:
        src: 'assets/css/style.css'
        dest: 'assets/css/style.css'

    uglify:
      default:
        src: 'assets/js/script.js'
        dest: 'assets/js/script.js'

      libs:
        src: 'assets/js/libs.js'
        dest: 'assets/js/libs.js'


    ###################################
    #  connect
    ###################################

    browserSync: {
        bsFiles: {
            src : ['assets/**/*', '**/*.html']
        },
        options: {
            watchTask: true
            server: {
                baseDir: "./"
            }
        }
    }


    ###################################
    #  watch
    ###################################

    watch:
      options: # enable livereload
        livereload: true
      compass: # watch scss files
        files: 'source/sass/**/*.scss'
        tasks: ['compass:dev']
      coffee: # watch scss files
        files: 'source/coffee/**/*.coffee'
        tasks: ['coffee:compile']
      js: # watch js files
        files: ['source/libs/js/**/*.js']
        tasks: ['concat:libs_js']
      sprites: # watch sprites files
        files: 'source/sprites/**'
        tasks: ['exec:mv_sprite', 'compass:dev']
      html: # watch html files
        files: '**/*.html'
        tasks: []


  ###################################
  #
  #  load
  #
  ###################################

  grunt.loadNpmTasks('grunt-autoprefixer')
  grunt.loadNpmTasks('grunt-browser-sync');
  grunt.loadNpmTasks('grunt-combine-media-queries')
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-csscomb')
  grunt.loadNpmTasks('grunt-csso')
  grunt.loadNpmTasks('grunt-exec')


  ###################################
  #
  #  tasks
  #
  ###################################

  # defalt
  grunt.registerTask('default', ['browserSync', 'watch']);

  # development
  grunt.registerTask('dev', ['clean', 'copy:images', 'exec:mv_sprite', 'compass:dev', 'coffee:compile', 'concat:libs_js']);

  # distribution
  grunt.registerTask('dist', ['clean', 'copy:images', 'exec:mv_sprite', 'compass:dist', 'autoprefixer', 'cmq', 'csscomb', 'csso', 'concat:license_css', 'coffee:compile', 'concat:libs_js', 'uglify', 'uglify:libs', 'concat:license_js']);

  return
