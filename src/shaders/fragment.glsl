precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;
varying vec3 vNormal;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

void main() {
    vec4 textureColor  = texture2D(uTexture, fract(vUv * 10.0));

    vec3 lighting      = vec3(0.0);
    vec3 normal        = normalize(vNormal);

    
    // Hemisphere lighting
    vec3  skyLight     = vec3(0.0, 0.3, 0.6);                   // From above 
    vec3  groundLight  = vec3(0.6, 0.3, 0.1);                   // From below
    float hemiMix      = remap(normal.y, -1.0, 1.0, 0.0, 1.0);  // Remap the normal to a value between 0 and 1
    vec3  hemiLight    = mix(groundLight, skyLight, hemiMix);   // Mix the ground and sky light based on the normal

    vec3  ambientLight = vec3(0.5);                             // Not from any particular direction, just ambient lighting

    lighting += ambientLight * 0.0 + hemiLight;                 // Lighting is the sum of all the light contributions

    vec3  color        = textureColor.rgb + lighting;

    color = textureColor.rgb;

    gl_FragColor       = vec4(color, 1.0);
}