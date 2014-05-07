module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-cssmin"

  grunt.initConfig uglify:
    options:
      mangle: false
    dev:
      files:
        "client/app.min.js": "client/app.js"

  grunt.initConfig cssmin:
    options:
      keepSpecialComments:0
    combine:
      files:
        "client/css/combined.min.css": ["client/css/style.css", "client/css/animate.css"]