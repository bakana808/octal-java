##NAME##
	5tick Pulser
##OUTPUTS##
	x

@interval = 5

if(@outputs[x] == 0){

	@outputs[x] = 1
	
}else{

	@outputs[x] = 0

}