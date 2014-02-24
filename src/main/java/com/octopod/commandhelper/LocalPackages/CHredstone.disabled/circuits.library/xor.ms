name: XOR Circuit
inputs: @x1 @x2
outputs: @y
persist: @a
block:

if(@x1 == @x2){
	@y = 1
}else{
	@y = 0
}