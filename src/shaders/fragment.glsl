precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

uniform vec3 uCameraPosition;

varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPosition;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

// SimonDev, GLSL Shaders From Scratch, https://simondev.teachable.com/courses/1783153
vec3 linearTosRGB(vec3 value ) {
  vec3 lt = vec3(lessThanEqual(value.rgb, vec3(0.0031308)));
  
  vec3 v1 = value * 12.92;
  vec3 v2 = pow(value.xyz, vec3(0.41666)) * 1.055 - vec3(0.055);

	return mix(v2, v1, lt);
}

void main() {
    vec4 textureColor  = texture2D(uTexture, fract(vUv * 10.0));

    vec3 lighting      = vec3(0.0);
    vec3 normal        = normalize(vNormal);

    /*  
        - Since we are doing our lighting in world space, we need to get a hold of the world
          space view direction. That is, the direction from the current fragment to the camera.
        - We can compute the view direction by subtracting the world position (vPosition)
          from the camera position (uCameraPosition), and then normalizing the result.
    */

    vec3 viewDirection = normalize(uCameraPosition - vPosition);

    vec3  ambientLight = vec3(0.5);                       

    vec3  skyLight     = vec3(0.0, 0.3, 0.6);                   
    vec3  groundLight  = vec3(0.3, 0.6, 0.1);                   
    float hemiMix      = remap(normal.y, -1.0, 1.0, 0.0, 1.0);  
    vec3  hemiLight    = mix(groundLight, skyLight, hemiMix);   

    vec3  lightDirection = normalize(vec3(1.0, 1.0, 1.0));
    float dp             = max(0.0, dot(normal, lightDirection));
    vec3  sunlightColor  = vec3(1.0, 1.0, 0.9);
    vec3  sunlight       = sunlightColor * dp;

    // Phong Specular
    vec3 r = normalize(reflect(-lightDirection, normal));
    float phongValue = max(dot(r, viewDirection), 0.0);
    phongValue = pow(phongValue, 32.0);

    vec3 specular = vec3(phongValue);

    lighting += ambientLight * 0.0 + hemiLight * 0.5 + sunlight * 0.5;                 

    vec3  color          = textureColor.rgb * 0.2 + lighting + specular;   

    //color                = linearTosRGB(color);       // linear to sRGB conversion
    color                = pow(color, vec3(1.0 / 2.2)); // pow(1.0 / 2.2) approximation

    gl_FragColor         = vec4(color, 1.0);
}