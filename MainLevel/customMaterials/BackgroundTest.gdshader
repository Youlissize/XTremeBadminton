shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(sin(UV.x+TIME)*0.4+0.6, UV.y*0.6, (1.0 - 0.5*sin(UV.x-TIME))*abs(sin(UV.x*2.2+UV.y*0.872 -TIME)), 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
