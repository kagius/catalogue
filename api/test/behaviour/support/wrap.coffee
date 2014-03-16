wrap = (fn, callback) ->
	fn.end (error) ->
		if error?
			callback.fail(throw(error))
		else
			callback()

exports.wrap = wrap