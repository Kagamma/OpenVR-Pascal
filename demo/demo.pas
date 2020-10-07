program Demo;

{$H+}
{$mode objfpc}

uses
  SysUtils, Classes, GLFW31, Renderer, VR, GL, GLExt;

var
  Window: PGLFWwindow;

procedure HandleKey(Window: PGLFWWindow; Key, ScanCode, Action, Mods: Integer); cdecl;
begin
  if (key = GLFW_KEY_ESCAPE) and (Action = GLFW_PRESS) then
    glfwSetWindowShouldClose(window, 1);
end;

procedure InitWindow;
begin
  if glfwInit = 0 then
  begin
    Writeln('Cannot init GLFW!');
    Halt;
  end;
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
  Window := glfwCreateWindow(WIDTH, HEIGHT, 'OpenVR', nil, nil);
  if Window = nil then
  begin
    Writeln('Cannot create GLFW window!');
    Halt;
  end;
  glfwMakeContextCurrent(Window);
  glfwSetKeyCallback(Window, @HandleKey);
  glfwSwapInterval(1);
  if not Load_GL_version_4_3_CORE then
  begin
    Writeln('OpenGL 4.3 is required!');
    Halt;
  end;
end;

procedure FreeWindow;
begin
  glfwDestroyWindow(Window);
  glfwTerminate;
end;

begin;
  InitWindow;
  InitRenderer;
  InitVR;
  while glfwWindowShouldClose(Window) = 0 do
  begin
    LoopVR;
    glfwSwapBuffers(Window);
    glfwPollEvents;
  end;
  FreeVR;
  FreeRenderer;
  FreeWindow;
end.