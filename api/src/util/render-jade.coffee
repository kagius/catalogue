fs = require "fs"
jade = require "jade"

module.exports = class JadeRenderer 
	constructor : (@app) ->
		self = @
		@templates = {}

		compile = (repo, path, filename) ->
			name = file.slice(0, -5)

			if self.app.config.logging.trace
				console.log "Precompiling template #{name}"
				
			repo[name] = jade.compile fs.readFileSync(path + filename, 'utf8'), { filename: path + filename, pretty: false }

		files = fs.readdirSync @app.config.templates.path

		compile @templates, @app.config.templates.path, file for file in files when file.indexOf(".jade") != -1

		@render = (template, data) ->
			self.templates[template] { debug: true, data: data, globals: self.app.config.globals }
