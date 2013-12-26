'use strict';

module.exports = function(grunt) {

	grunt.initConfig({
		
		// Package information
		pkg: grunt.file.readJSON('package.json'),
		
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
	
	// Default task.
	grunt.registerTask('default', ['coffee', 'nodeunit']);
}