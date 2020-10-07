#version 410 core

layout(location = 0) in vec3 inVertex;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;

layout(location = 0) out vec2 fragTexCoord;
layout(location = 1) out vec4 fragColor;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;

void main(void) {
  fragTexCoord = inTexCoord;
  mat4 modelViewMatrix = viewMatrix * modelMatrix;
  gl_Position = (projMatrix * modelViewMatrix) * vec4(inVertex, 1.0);

  mat3 normalMatrix = mat3(transpose(inverse(modelViewMatrix)));
  vec3 vLight = (viewMatrix * vec4(0.0, 0.0, -20.0, 1.0)).xyz;
  vec3 vPos = (modelViewMatrix * vec4(inVertex, 1.0)).xyz;
  vec3 vNormal = normalize(normalMatrix * inNormal);
  vec3 vLightDir = normalize(vLight - vPos);

  vec3 diffuse = max(dot(vLightDir, vNormal), 0.0) * vec3(1.0);
  fragColor = vec4(diffuse + vec3(0.1), 1.0);
}