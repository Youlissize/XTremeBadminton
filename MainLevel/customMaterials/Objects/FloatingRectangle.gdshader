shader_type canvas_item;

uniform sampler2D noiseTexture;


void vertex() {
	// Called for every vertex the material is visible on.

}




void fragment() {
	// Called for every pixel the material is visible on.
	vec3 mainColor = vec3(0.1,0.1,0.2);
	vec3 secondColor = vec3(0.9,0.8,0.5);
	
	vec3 col = vec3(0);
	col = mix(mainColor, secondColor, pow(max(abs(UV.x-0.5), abs(UV.y-0.5)), 3.0)*6.0);
	
	COLOR = vec4(col,1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}