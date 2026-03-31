shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.
	// TODO : set the folliwing as parameters linked with the raquette
	vec3 color = vec3(1.0);
	//float maxHitDist = 200.0;
	float w = 0.01; //width
	
	float x = -UV.x+0.5;
	float y = -UV.y + 0.5;
	float r = sqrt(x*x + y*y);
	float phi = atan(y,x) * 57.2957795131; //180/PI
	float opacity = float(r>0.5-w && r<0.5);
	opacity *= float(fract(phi*0.1)>0.3);
	
	COLOR = vec4(color, opacity * 0.1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
