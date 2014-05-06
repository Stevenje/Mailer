module.exports = function (grunt) {
    grunt.loadNpmTasks("grunt-contrib-uglify");

    grunt.initConfig({
        uglify: {
            dev: {
                files:{
                    'client/app.min.js':'client/app.js'
                }
            }
        }
    });

    grunt.registerTask("default", function () {
        console.log("Hello World!");
    });
}