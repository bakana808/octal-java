name: AND Circuit
inputs:
outputs: @x
persist: @a
block:

@interval = 20

if(@x == 0){

	@x = 1
	
}else{

	@x = 0

}