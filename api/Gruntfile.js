'use strict';

module.exports = function(grunt) {

	grunt.initConfig({
		
		// Package information
		pkg: grunt.file.readJSON('package.json'),

		concurrent: {
		  dev: {
		    tasks: ['nodemon'],
		    options: {
		      logConcurrentOutput: true
		    }
		  }
		},

		// Cucumber tests
		cucumberjs: {
			src: 'test/behaviour/features',
			options: {
				steps: 'test/behaviour/steps'
			}
		},

		nodemon: {
			dev: {
				script: 'dist/application.js'
			}
		},
		
		// Coffescript compiler
		coffee: {
			compile: {
				options: {
					sourceMap: true
				},
				files: [{
					expand: true,
					flatten: true,
					src: ['src/**/*.coffee'],
					dest: 'dist/',
					ext: '.js'
				}]
			}
		},

		// Unit tests
		nodeunit: {
			files: ['test/**/*Test.js']
		}
	});

	// These plugins provide necessary tasks.
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-nodeunit');
	grunt.loadNpmTasks('grunt-cucumber');
	grunt.loadNpmTasks('grunt-nodemon');
	grunt.loadNpmTasks('grunt-concurrent');
	
	// Default task.
	grunt.registerTask('default', ['coffee', 'nodeunit', 'concurrent']);

	// Run
	grunt.registerTask('serve', ['nodemon']);

	grunt.registerTask('system-test', ['cucumberjs']);
}