precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;
varying float vElevation;

void main() {
    vec4 textureColor = texture2D(uTexture, fract(vUv * 10.0));

    vec3 lighting = vec3(0.0);

    vec3 ambientLight = vec3(0.5); // Not from any particular direction, just ambient lighting

    lighting += ambientLight;      // Lighting is the sum of all the light contributions

    vec3 color = textureColor.rgb + lighting;

    gl_FragColor = vec4(color, 1.0);
}