name: 7Segment Display
inputs: @1 @2
outputs: @a @b @c @d @e @f @g

if(@1 == 1) {

	if(@2 == 1) {
	
		@a = 1
		@b = 0
		@c = 1
		@d = 1
		@e = 0
		@f = 1
		@g = 1
		
	} else {
	
		@a = 0
		@b = 1
		@c = 1
		@d = 0
		@e = 0
		@f = 0
		@g = 0
		
	}
	
} else {

	@a = 1
	@b = 1
	@c = 1
	@d = 1
	@e = 1
	@f = 1
	@g = 0
	
}