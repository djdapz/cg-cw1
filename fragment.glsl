#version 130

//Vector to light source
in vec4 lightVec;
//Vector to eye
in vec4 eyeVec;
//Transformed normal vector
in vec4 normOut;

//A texture you might want to use (optional)
uniform sampler2D tex;

//Output colour
out vec4 outColour;

/* Standard operations work on vectors, e.g.
	light + eye
	light - eye
   Single components can be accessed (light.x, light.y, light.z, light.w)
   C style program flow, e.g. for loops, if statements
   Can define new variables, vec2, vec3, vec4, float
   No recursion
   Example function calls you might find useful:
	max(x,y) - maximum of x and y
	dot(u,v) - dot product of u and v
	normalize(x) - normalise a vector
	pow(a,b) - raise a to power bsing the texture provided in combination with the Phong shading in
fragment.gls
	texture(t,p) - read texture t at coordinates p (vec2 between 0 and 1)
	mix(a,b,c) - linear interpolation between a and b, by c. (You do not need to use this to interpolate vertex attributes, OpenGL will take care of interpolation between vertices before calling the fragment shader)
   outColour is a vec4 containing the RGBA colour as floating point values between 0 and 1. outColour.r, outColour.g, outColour.b and outColour.a can be used to access the components of a vec4 (as well as .x .y .z .w)
*/

float calcDiffuse(vec4 norm, vec4 light, float intensity, float diff){
	float cosTheta = max(0, dot(norm, light));
	float Idiff = intensity * diff * cosTheta;
	return Idiff;
}


float calcSpec(vec4 norm, vec4 light, float intensity, float spec){
	float cosAlpha = max(0, dot((2*norm*dot(norm,light) - light), eyeVec));
	float Ispec = intensity * spec * pow(cosAlpha, 10);
	return Ispec;
}

void main() {	
	//Modify this code to calculate Phong illumination based on the inputs
	float diff=0.8;
	float spec=0.2;
	float ambient=0.2;
	float intensity = 1.0;
	float lamb = 0.2;
	float n = 10;
	
	vec4 light = normalize(lightVec);
	vec4 norm = normalize(normOut);
	
	float Idiff = calcDiffuse(norm, light, intensity, diff);
	float Ispec = calcSpec(norm, light, intensity, spec);
	
	//outColour = vec4(spec+ambient, spec+diff+ambient, spec+ambient, 1.0);
	outColour = vec4(ambient+Ispec+Idiff, ambient+Ispec, ambient+Ispec, 0) ;
}

