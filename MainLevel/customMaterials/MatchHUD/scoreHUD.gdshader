shader_type canvas_item;
uniform sampler2D noiseTexture;

void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 colLeft = vec3(1.0,0.2,0.0);
	vec3 colRight = vec3(0.0,0.3,0.8);
	float borderSize = 0.1;
	float bs = 0.3;
	
	vec3 col = vec3(0);
	float opacity = 1.0;
	
	float f = smoothstep(borderSize,borderSize+bs, UV.x);
	col = mix(colLeft, col, f);
	f = smoothstep(1.0-borderSize-bs,1.0-borderSize, UV.x);
	col = mix(col, colRight, f);
	
	vec4 tex = texture(noiseTexture, vec2(fract(0.03*TIME + UV.y),0.2*UV.x));
	col *= tex.xyz;
	f = smoothstep(0,bs, UV.x) - smoothstep(1.0-bs,1.0, UV.x);
	float ff = smoothstep(0,bs*0.5, UV.x) - smoothstep(1.0-bs*0.5,1.0, UV.x);
	opacity *= mix(tex.x*ff, 1.0, f);

	COLOR = vec4(col.x, col.y, col.z , opacity);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
