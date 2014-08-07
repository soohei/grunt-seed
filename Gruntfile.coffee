module.exports = (grunt) ->
  # load package.json
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    compass:
      dist:
        options:
          config: 'config.rb'
          outputStyle: 'compressed'
          environment: 'production'
      dev:
        options:
          config: 'config.rb'

    coffee:
      compile:
        options:
          join: true
        files:
          'source/js/script.js': ['source/coffee/**/*.coffee']

    exec:
      mv_sprite:
        cmd: 'ruby mv_sprite.rb'

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

    concat:
      jsdefault:
        src: [
          'source/jslib/**/*.js'
          'source/js/**/*.js'
        ]
        dest: 'assets/js/script.js'

      license: {
        src: [
          'source/jslib/_license.js'
          'assets/js/script.js'
        ]
        dest: 'assets/js/script.js'
      }

    uglify:
      default:
        src: 'assets/js/script.js'
        dest: 'assets/js/script.js'

    connect:
      uses_defaults: {}

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
        files: ['source/js/**/*.js', 'source/jslib/**/*.js']
        tasks: ['concat:jsdefault']
      image: # watch image files
        files: 'source/images/**'
        tasks: ['exec:mv_sprite']
      html: # watch html files
        files: '**/*.html'

  # load Grunt Plugins
  grunt.loadNpmTasks('grunt-autoprefixer')
  grunt.loadNpmTasks('grunt-combine-media-queries')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-csscomb')
  grunt.loadNpmTasks('grunt-csso')
  grunt.loadNpmTasks('grunt-exec')

  # tasks

  # defalt
  grunt.registerTask('default', ['connect', 'watch']);

  # development
  grunt.registerTask('dev', ['exec:mv_sprite', 'compass:dev', 'coffee:compile', 'concat:jsdefault']);

  # distribution
  grunt.registerTask('dist', ['exec:mv_sprite', 'compass:dist', 'autoprefixer', 'cmq', 'csscomb', 'csso', 'coffee:compile', 'concat:jsdefault', 'uglify', 'concat:license']);

  return
