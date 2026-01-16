shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.
	// TODO : set the folliwing as parameters linked with the raquette
	float minHitDist = 50.0;
	float maxHitDist = 200.0;
	float distMinUV = 0.5 * minHitDist / maxHitDist;
	
	float angleTopStart = 30.0;
	float angleTopEnd = 140.0;
	float angleBotStart = 80.0;
	float angleBotEnd = 170.0;
	
	float x = -UV.x+0.5;
	float y = -UV.y + 0.5;
	
	float r = sqrt(x*x + y*y);
	float phi = atan(y,x) * 57.2957795131; //180/PI
	
	phi = abs(phi);
	
	float opacity = 0.0;
	float e = 0.05; //epaisseur du trait
	vec3 color = vec3(1.0,1.0,1.0);
	if ( r < 0.5 && r > distMinUV )
	{
		if ((y>0.0) && (phi<angleTopEnd && phi>angleTopStart))
			{opacity = pow(1.0-(2.0*min(0.5-r , r-distMinUV)), 10)  ; 
			color = vec3(phi * 0.005, 1.0 - phi * 0.005, 0.1);
			} 
		else if (y<0.0 && (phi<angleBotEnd && phi>angleBotStart))
			{opacity = pow(1.0-(2.0*min(0.5-r , r-distMinUV)), 10);
			color = vec3(1.0-phi * 0.005, 1.0-phi * 0.002 , phi * 0.002); } 
			
	}
	
	
	
	COLOR = vec4(color.x, color.y, color.z , opacity * 0.3);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
