shader_type canvas_item;

uniform sampler2D noiseTexture;


void vertex() {
	// Called for every vertex the material is visible on.

}




void fragment() {
	// Called for every pixel the material is visible on.
	vec2 center = vec2(0.5,0.5);
	float radius = 0.04;
	float blend = 0.05;
	float zoom = 1.0;
	vec3 mainColor = vec3(1.1,0.1,1.2);
	vec3 secondColor = vec3(1.6,1.5,0.5);
	float attractionInt = 1.0;
	float attractionOffset = 0.02;
	float contrast = 2.5;
	float luminosity = 2.0;
	float centerBright = 2.0;
	
	vec2 coord = zoom * (UV-center);
	float r = length(coord);
	float a = atan(coord.y,coord.x) / PI;
	
	float f;
	vec3 col = vec3(0.0);
	
	// Main Texture
	float da = TIME * 0.01 + attractionInt * pow(0.01/(r-radius+attractionOffset), 1.4);
	float dr = TIME * 0.05;
	vec4 tex = texture(noiseTexture, vec2(fract(0.03*TIME),fract(0.5*r)));
	tex = texture(noiseTexture, vec2(fract(r+dr + 0.0* tex.x),fract(a+da + 0.12* tex.x)));
	col += tex.xyz * mainColor;
	
	//secondary Texture
	float dda = sin(TIME * 2.5) * 0.01  ;
	float ddr = cos(TIME * 2.5) * 0.02;
	tex = texture(noiseTexture, vec2(fract(r+dr+ddr),fract(a+da+dda)));
	col = mix(col, tex.xyz * secondColor, 0.3*(tex.x+tex.y+tex.z));
	
	//black Texture
	tex = texture(noiseTexture, vec2(fract(0.8*r - 0.08*TIME),fract(2.0*a+0.453)));
	col *=  0.5 + 0.5*pow(tex.x, 0.8);
	
	//Contrast and Luminosity
	col = vec3(pow(col.x, contrast),pow(col.y, contrast),pow(col.z, contrast));
	col *= luminosity;
	
	// Add Black + Bright on center and borders
	f = smoothstep(radius,radius+blend,r);
	col *= f;
	f = smoothstep(0.0 ,4.0*radius,r);
	col *= 1.0 + centerBright*(1.0-f);
	f = smoothstep(0.3,0.5,r);
	col *= 1.0-f;
	float opacity = (1.0-f)*(col.x+col.y+col.z)*3.0;
	
	COLOR = vec4(col,opacity*opacity);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}