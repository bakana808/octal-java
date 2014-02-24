
proc(_factoid_get, @name,

	@factoid = import('factoidCache.'.@name)
	
	if(@factoid == null,
	
		try(@factoid = read('factoids/'.@name.'.txt'), return(null))
		
	)
	
	export('factoidCache.'.@name, @factoid)
	
	return(@factoid)
	
)

proc(_factoid_set, @name, @text,

	try(
		write('factoids/'.@name.'.txt', @text)
		export('factoidCache.'.@name, @text)
		return(true),
		return(false)
	)
	
)