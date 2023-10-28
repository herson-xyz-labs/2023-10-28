precision mediump float;

uniform vec3 uColor;
uniform sampler2D uTexture;

varying vec2 vUv;
varying float vElevation;

void main() {
    vec4 textureColor = texture2D(uTexture, fract(vUv * 10.0));
    textureColor.rgb *= vElevation * 2.0 + 0.5;
    gl_FragColor = textureColor;
}