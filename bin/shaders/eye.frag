#version 410 core

precision mediump float;

layout(location = 0) in vec2 fragTexCoord;

layout(location = 0) out vec4 outColor;

uniform sampler2D tex;

void main() {
  outColor = texture(tex, fragTexCoord);
}