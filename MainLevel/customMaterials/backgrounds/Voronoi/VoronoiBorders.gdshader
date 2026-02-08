shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.

}

vec2 random2(vec2 x)
{
	vec2 rand = vec2( dot(x,vec2(127.1,311.7)), dot(x,vec2(269.5,183.3)));
	rand = fract(sin(rand)*43758.5453);
	return rand + 0.2 * sin(0.5*TIME+4.0*rand) + 0.2 * cos(0.5*TIME+4.0*rand) ;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 coord = 1.95 * UV/(SCREEN_PIXEL_SIZE *140.0) ;//UV*7.0; // Tilling
	float w = 1.0; //Smoothness
	
    ivec2 p = ivec2(floor( coord ));
    vec2  f = fract( coord );

    ivec2 mb;
    vec2 mr;

    float res = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        ivec2 b = ivec2(i, j);
		vec2 rand = vec2(0);//random2f(p+b);
        vec2  r = vec2(b) + random2(vec2(p+b)) -f;
        float d = dot(r,r);

        if( d < res )
        {
            res = d;
            mr = r;
            mb = b;
        }
    }

    res = 8.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        ivec2 b = mb + ivec2(i, j);
		
        vec2  r = vec2(b) +  random2(vec2(p+b)) - f;
		
        float d = dot(0.5*(mr+r), normalize(r-mr));

        res = min( res, d );
    }
	float off = 0.2 + 0.1 * sin(TIME*0.5)  + res;
	off = clamp(off,0.0,1.0);
	vec3 col = vec3(res,0.0,0.3*pow((1.0-off)*off*4.0, 4));
	
	col *= 3.5; //luminosity
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
