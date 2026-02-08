shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 coord = 15.0 * UV/(SCREEN_PIXEL_SIZE *140.0) ;//UV*7.0; // Tilling
	float w = 1.6; //Smoothness
	
    vec2 n = floor( coord );
    vec2 f = fract( coord );

	vec4 m = vec4( 8.0, 0.0, 0.0, 0.0 );
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = vec2( float(i),float(j) );
		// Hasing n+g
		vec2 p = n+g;
		p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)));
        vec2 o = fract(sin(p)*43758.5453);
		
		// animate
        o = 0.5 + 0.5*sin( TIME*0.4 + 16.2831*o );

        // distance to cell		
		float d = length(g - f + o);
		
        // cell color
		vec3 col = 0.5 + 0.5*sin( fract(sin(dot(n+g,vec2(7.0,113.0)))*43758.5453) * 2.5 + 3.5 + vec3(1.0,0.5,-3.1));
        // in linear space
        col = col*col;
        
        // do the smooth min for colors and distances		
		float h = smoothstep( -1.0, 1.0, (m.x-d)/w );
	    m.x   = mix( m.x,     d, h ) - h*(1.0-h)*w/(1.0+3.0*w); // distance
		m.yzw = mix( m.yzw, col, h ) - h*(1.0-h)*w/(1.0+3.0*w); // color
    }
	
	vec4 v = m;
	vec3 col = sqrt(v.yzw);
	float shape = 0.5 * (1.2 + tan( 3.0 *v.x)) ; // use distance to cell center for cool things
	shape = clamp(shape,0.0,8.0);
	col *= shape;
	
	col *= 0.5; //luminosity
	float dist = (UV.x-0.5)*(UV.x-0.5)+(UV.y-0.5)*(UV.y-0.5);
	col *= 1.0- pow(2.0*dist, 0.1); // dark on angles
	
	COLOR = vec4(col,1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
/*
vec4 voronoi( in vec2 x, float w )
{
    vec2 n = floor( x );
    vec2 f = fract( x );

	vec4 m = vec4( 8.0, 0.0, 0.0, 0.0 );
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = vec2( float(i),float(j) );
        vec2 o = hash2( n + g );
		
		// animate
        o = 0.5 + 0.5*sin( iTime + 6.2831*o );

        // distance to cell		
		float d = length(g - f + o);
		
        // cell color
		vec3 col = 0.5 + 0.5*sin( hash1(dot(n+g,vec2(7.0,113.0)))*2.5 + 3.5 + vec3(2.0,3.0,0.0));
        // in linear space
        col = col*col;
        
        // do the smooth min for colors and distances		
		float h = smoothstep( -1.0, 1.0, (m.x-d)/w );
	    m.x   = mix( m.x,     d, h ) - h*(1.0-h)*w/(1.0+3.0*w); // distance
		m.yzw = mix( m.yzw, col, h ) - h*(1.0-h)*w/(1.0+3.0*w); // color
    }
	
	return m;
}
*/
