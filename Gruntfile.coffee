module.exports = (grunt) ->

  require('time-grunt') grunt

  ###
  Dynamically load npm tasks
  ###
  require('jit-grunt') grunt

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.initConfig

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
        src: ['test/**/*.coffee']

  grunt.registerTask "default", [
    "mochaTest"
  ]

  grunt.registerTask "test", [
    "mochaTest"
  ]

  return
