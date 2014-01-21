
#======================================================================================================#
#	Vector Functions
#======================================================================================================#

proc(_v2, return(call_proc_array('_vector2', @arguments)))
proc(_vector2, @x = 0, @y = 0, return(array(@x, @y)))

proc(_v, return(call_proc_array('_vector3', @arguments)))
proc(_vector3, @x = 0, @y = 0, @z = 0, return(array(@x, @y, @z)))

proc(_v4, return(call_proc_array('_vector4', @arguments)))
proc(_vector4, @x = 0, @y = 0, @z = 0, @a = 0, return(array(@x, @y, @z, @a)))

proc(_vec2_add, @vec1, @vec2,

	@vec = array(@vec1[0] + @vec2[0], @vec1[1] + @vec2[1])
	
	foreach(@vec1, @i, @a,
		if(!array_contains(range(0,3), @i),
			@vec[@i] = @a
		)
	)
	
	return(@vec)
	
)

proc(_vec_dimension, @vec,
	@dimension = 0
	if(is_associative(@vec)) {
		if(array_index_exists(@vec, x) || array_index_exists(@vec, 0), @dimension++)
		if(array_index_exists(@vec, y) || array_index_exists(@vec, 1), @dimension++)
		if(array_index_exists(@vec, z) || array_index_exists(@vec, 2), @dimension++)
		if(array_index_exists(@vec, a) || array_index_exists(@vec, 3), @dimension++)
		return(@dimension)
	} else {
		foreach(@vec, @value,
			if(!is_numeric(@value), return(@dimension))
			@dimension++
		)
		return(@dimension)
	}
)

proc(_vec_add, @vec1, @vec2,

	@vec = array(@vec1[0] + @vec2[0], @vec1[1] + @vec2[1], @vec1[2] + @vec2[2])
	
	foreach(@vec1, @i, @a,
		if(!array_contains(range(0,3), @i),
			@vec[@i] = @a
		)
	)
	
	return(@vec)
	
)

proc(_vec_sub, @vec1, @vec2,

	@vec = array(@vec1[0] - @vec2[0], @vec1[1] - @vec2[1], @vec1[2] - @vec2[2])
	
	foreach(@vec1, @i, @a,
		if(!array_contains(range(0,3), @i),
			@vec[@i] = @a
		)
	)
	
	return(@vec)
	
)

proc(_vec_dist, @loc1, @loc2,

	@x = pow((@loc1[0] - @loc2[0]), 2)
	@y = pow((@loc1[1] - @loc2[1]), 2)
	@z = pow((@loc1[2] - @loc2[2]), 2)
	
	@dist = sqrt(@x + @y + @z)
	
	return(@dist)
	
)

proc(_math_average_loc, @locarray,

	@x = 0
	@y = 0
	@z = 0
	
	foreach(@locarray, @loc,
	
		@x = @x + @loc[0]
		@y = @y + @loc[1]
		@z = @z + @loc[2]
		
	)
	
	@x = round(@x / array_size(@locarray))
	@y = round(@y / array_size(@locarray))
	@z = round(@z / array_size(@locarray))
	
	return(array(@x, @y, @z))
	
)

proc(_vec_average, @locarray,

	@vectors = array_size(@locarray)
	
	if(@vectors == 0, return(array(0,0,0)))

	@x = 0
	@y = 0
	@z = 0
	
	foreach(@locarray, @loc,
		@x += @loc[0]
		@y += @loc[1]
		@z += @loc[2]
	)
	
	@x = round(@x / @vectors)
	@y = round(@y / @vectors)
	@z = round(@z / @vectors)
	
	return(array(@x, @y, @z))
	
)

proc(_vec_mult, @vec1, @vec,

	if(!is_array(@vec)) {
		@vec = array(@vec, @vec, @vec)
	}

	@vec1[0] = @vec1[0] * @vec[0]
	@vec1[1] = @vec1[1] * @vec[1]
	@vec1[2] = @vec1[2] * @vec[2]
	
	return(@vec1)
	
)

proc(_vec_normalize, @vec,

	@l = _vec_magnitude(@vec)
	
	if(@l == 0, return(array(0,0,0)))
	
	@vec[0] = (@vec[0] / @l)
	@vec[1] = (@vec[1] / @l)
	@vec[2] = (@vec[2] / @l)
	
	return(@vec)
	
)

proc(_vec_magnitude, @vec,

	@l = sqrt(pow(@vec[0], 2) + pow(@vec[1], 2) + pow(@vec[2], 2))
	
	return(@l)
	
)

