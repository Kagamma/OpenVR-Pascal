#version 410 core

layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec2 inTexCoord;

layout(location = 0) out vec2 fragTexCoord;

void main(void) {
  fragTexCoord = inTexCoord;
  gl_Position = vec4(inPosition.xy, 0.0, 1.0);
}