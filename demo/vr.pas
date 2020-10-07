unit vr;

interface

uses
  SysUtils, GL, GLExt, openvr_api, Math3D;

const
  WIDTH = 1366;
  HEIGHT = 768;
  EyeVerticles: array[0..31] of GLfloat = (
    -0.9, -0.9, 0.0, 0.0,
    -0.05, -0.9, 1.0, 0.0,
    -0.05, 0.9, 1.0, 1.0,
    -0.9, 0.9, 0.0, 1.0,
    // Right eye
    0.05, -0.9, 0.0, 0.0,
    0.9, -0.9, 1.0, 0.0,
    0.9, 0.9, 1.0, 1.0,
    0.05, 0.9, 0.0, 1.0
  );
  EyeIndices: array[0..11] of GLushort = (
    0, 1, 2, 0, 2, 3, 4, 5, 6, 4, 6, 7
  );

type
  TOVRDeviceName = array[0..1023] of Char;

  TOVRMesh = record
    VertexArray,
    VertexBuffer,
    ArrayBuffer,
    Texture,
    VertexCount: GLuint;
  end;

  TController = record
    Side: Integer; // 0 = left, 1 = right
    DeviceID: Integer;
    DeviceName: TOVRDeviceName;
    Mesh: TOVRMesh;
    Pose: TMatrix4f;
    ActionPose: VRActionHandle_t;
  end;

  TFrameBuffer = record
    DepthID,
    RenderFramebufferID,
    RenderTextureID,
    ResolveFramebufferID,
    ResolveTextureID: GLuint;
  end;

procedure InitVR;
procedure FreeVR;
procedure LoopVR;

var
  IVRSystem: PIVRSystem;
  IVRCompositor: PIVRCompositor;
  IVRRenderModels: PIVRRenderModels;
  IVRInput: PIVRInput;
  EyeLeftProj,
  EyeRightProj,
  EyeLeftPose,
  EyeRightPose: TMatrix4f;
  EyeLeftFB,
  EyeRightFB: TFrameBuffer;
  Controllers: array[0..1] of TController;
  TrackedDevicePoses: array[0..7] of TrackedDevicePose_t;
  Poses: array[0..7] of TMatrix4f;
  HmdPose: TMatrix4f;
  RenderWidth,
  RenderHeight: LongWord;
  EyeVAO,
  EyeEAB,
  EyeVBO: GLuint;

implementation

uses
  Renderer;

function ConvertVR34ToMatrix(const M: HmdMatrix34_t): TMatrix4f;
begin
  Result[0,0] := M.m[0,0]; Result[0,1] := M.m[1,0]; Result[0,2] := M.m[2,0]; Result[0,3] := 0;
  Result[1,0] := M.m[0,1]; Result[1,1] := M.m[1,1]; Result[1,2] := M.m[2,1]; Result[1,3] := 0;
  Result[2,0] := M.m[0,2]; Result[2,1] := M.m[1,2]; Result[2,2] := M.m[2,2]; Result[2,3] := 0;
  Result[3,0] := M.m[0,3]; Result[3,1] := M.m[1,3]; Result[3,2] := M.m[2,3]; Result[3,3] := 1;
end;

procedure FindHmdEye(const Eye: EVREye; out Pose, Proj: TMatrix4f);
const
  FNear: Single = 0.1;
  FFar: Single = 100;
begin
  Pose := Inverse(ConvertVR34ToMatrix(IVRSystem^.GetEyeToHeadTransform(Eye)));
  Proj := Transpose(TMatrix4f(IVRSystem^.GetProjectionMatrix(Eye, FNear, FFar)));
end;

function CreateFrameBuffer(const Width, Height: Integer): TFrameBuffer;
var
  Status: GLenum;
begin
  glGenFramebuffers(1, @Result.RenderFramebufferID);
  glBindFramebuffer(GL_FRAMEBUFFER, Result.RenderFramebufferID);

  glGenRenderbuffers(1, @Result.DepthID);
  glBindRenderbuffer(GL_RENDERBUFFER, Result.DepthID);
  glRenderbufferStorageMultisample(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT, Width, Height);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,	Result.DepthID);

  glGenTextures(1, @Result.RenderTextureID);
  glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, Result.RenderTextureID);
  glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 4, GL_RGBA8, Width, Height, GL_TRUE);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D_MULTISAMPLE,	Result.RenderTextureID, 0);

  Status := glCheckFramebufferStatus(GL_FRAMEBUFFER);
  if Status <> GL_FRAMEBUFFER_COMPLETE then
  begin
    Writeln('Failed to create framebuffer 1');
    Halt;
  end;
  glGenFramebuffers(1, @Result.ResolveFramebufferID);
  glBindFramebuffer(GL_FRAMEBUFFER, Result.ResolveFramebufferID);

  glGenTextures(1, @Result.ResolveTextureID);
  glBindTexture(GL_TEXTURE_2D, Result.ResolveTextureID);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,	Result.ResolveTextureID, 0);

  Status := glCheckFramebufferStatus(GL_FRAMEBUFFER);
  if Status <> GL_FRAMEBUFFER_COMPLETE then
  begin
    Writeln('Failed to create framebuffer 2');
    Halt;
  end;
  glBindFramebuffer(GL_FRAMEBUFFER, 0);
end;

function LoadOVRMesh(DI: TrackedDeviceIndex_t): TController;
var
  TPError: ETrackedPropertyError;
  RMError: EVRRenderModelError;
  POVRRenderModel: ^RenderModel_t = nil;
  POVRRenderTexture: ^RenderModel_TextureMap_t = nil;
  Side: Integer = -1;
  Role: LongInt;
  I: Integer;
  IsLoaded: Boolean = True;
begin
  Result.Side := -1;
  Result.DeviceID := DI;
  // We only want to load controller mesh
  if IVRSystem^.GetTrackedDeviceClass(DI) <> TrackedDeviceClass_Controller then
    Exit;
  FillChar(Result.DeviceName, 1024, 0);
  IVRSystem^.GetStringTrackedDeviceProperty(DI, Prop_RenderModelName_String, @Result.DeviceName, 1024, @TPError);
  Role := IVRSystem^.GetInt32TrackedDeviceProperty(DI, Prop_ControllerRoleHint_Int32, @TPError);
  case ETrackedControllerRole(Role) of
    TrackedControllerRole_LeftHand:
      Side := 0;
    TrackedControllerRole_RightHand:
      Side := 1;
  end;
  if Side < 0 then
    Exit;
  for I := 0 to 1023 do
  begin
    if Controllers[Side].DeviceName[I] <> Result.DeviceName[I] then
    begin
      IsLoaded := False;
      break;
    end;
  end;
  if IsLoaded then Exit;
  Result.Side := Side;
  Writeln('Device name: ', PChar(@Result.DeviceName));
  repeat
    RMError := IVRRenderModels^.LoadRenderModel_Async(@Result.DeviceName, @POVRRenderModel);
    Sleep(1);
  until RMError <> VRRenderModelError_Loading;
  if RMError <> VRRenderModelError_None then
  begin
    Writeln('LoadRenderModel_Async(', PChar(@Result.DeviceName), '): ', IVRRenderModels^.GetRenderModelErrorNameFromEnum(RMError));
  end;
  repeat
    RMError := IVRRenderModels^.LoadTexture_Async(POVRRenderModel^.diffuseTextureId, @POVRRenderTexture);
    Sleep(1);
  until RMError <> VRRenderModelError_Loading;
  if RMError <> VRRenderModelError_None then
  begin
    Writeln('LoadTexture_Async(', PChar(@Result.DeviceName), '): ', IVRRenderModels^.GetRenderModelErrorNameFromEnum(RMError));
  end;

  // create and bind a VAO to hold state for this model
  glGenVertexArrays(1, @Result.Mesh.VertexArray);
  glBindVertexArray(Result.Mesh.VertexArray);

  // Populate a vertex buffer
  glGenBuffers(1, @Result.Mesh.VertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, Result.Mesh.VertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, SizeOf(RenderModel_Vertex_t) * POVRRenderModel^.unVertexCount, POVRRenderModel^.rVertexData, GL_STATIC_DRAW);

  // Identify the components in the vertex buffer
  glEnableVertexAttribArray(0);
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 32, Pointer(0));
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 32, Pointer(12));
  glEnableVertexAttribArray(2);
  glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 32, Pointer(24));

  // Create and populate the index buffer
  glGenBuffers(1, @Result.Mesh.ArrayBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, Result.Mesh.ArrayBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, SizeOf(Word) * POVRRenderModel^.unTriangleCount * 3, POVRRenderModel^.rIndexData, GL_STATIC_DRAW);

  glBindVertexArray(0);

  // create and populate the texture
  glGenTextures(1, @Result.Mesh.Texture);
  glBindTexture(GL_TEXTURE_2D, Result.Mesh.Texture);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, POVRRenderTexture^.unWidth, POVRRenderTexture^.unHeight,
    0, GL_RGBA, GL_UNSIGNED_BYTE, POVRRenderTexture^.rubTextureMapData);

  // If this renders black ask McJohn what's wrong.
  glGenerateMipmap(GL_TEXTURE_2D);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
  glBindTexture(GL_TEXTURE_2D, 0);
  glBindVertexArray(0);

  Result.Mesh.VertexCount := POVRRenderModel^.unTriangleCount * 3;
end;

procedure LoadEyeMesh;
begin
  glGenVertexArrays(1, @EyeVAO);
  glBindVertexArray(EyeVAO);

  glGenBuffers(1, @EyeVBO);
  glBindBuffer(GL_ARRAY_BUFFER, EyeVBO);
  glBufferData(GL_ARRAY_BUFFER, SizeOf(EyeVerticles), @EyeVerticles, GL_STATIC_DRAW);

  glGenBuffers(1, @EyeEAB );
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EyeEAB);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, SizeOf(EyeIndices), @EyeIndices, GL_STATIC_DRAW);

  glEnableVertexAttribArray(0);
  glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 16, Pointer(0));

  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 16, Pointer(8));

  glBindVertexArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
end;

procedure InitVR;
var
  Error: EVRInitError;
  FnTableName: AnsiString;
begin
  if not OpenVR_Load() then
  begin
    Writeln('Cannot init OpenVR!');
    Halt;
  end;
  if not VR_IsHmdPresent() then
  begin
    Writeln('VR headset not found!');
    Halt;
  end;
  if not VR_IsRuntimeInstalled() then
  begin
    Writeln('OpenVR runtime is not installed!');
    Halt;
  end;
  VR_InitInternal(@Error, VRApplication_Scene);
  if Error <> VRInitError_None then
  begin
    Writeln('VR_InitInternal: ', Error);
    Halt;
  end;
  FnTableName := 'FnTable:' + IVRSystem_Version + #0;
  IVRSystem := PIVRSystem(VR_GetGenericInterface(PChar(FnTableName), @Error));
  if Error <> VRInitError_None then
  begin
    Writeln('VR_GetGenericInterface(', IVRSystem_Version, '): ', Error);
    Halt;
  end;
  FnTableName := 'FnTable:' + IVRCompositor_Version + #0;
  IVRCompositor := PIVRCompositor(VR_GetGenericInterface(PChar(FnTableName), @Error));
  if Error <> VRInitError_None then
  begin
    Writeln('VR_GetGenericInterface(', IVRCompositor_Version, '): ', Error);
    Halt;
  end;
  FnTableName := 'FnTable:' + IVRRenderModels_Version + #0;
  IVRRenderModels := PIVRRenderModels(VR_GetGenericInterface(PChar(FnTableName), @Error));
  if Error <> VRInitError_None then
  begin
    Writeln('VR_GetGenericInterface(', IVRRenderModels_Version, '): ', Error);
    Halt;
  end;
  FnTableName := 'FnTable:' + IVRInput_Version + #0;
  IVRInput := PIVRInput(VR_GetGenericInterface(PChar(FnTableName), @Error));
  if Error <> VRInitError_None then
  begin
    Writeln('VR_GetGenericInterface(', IVRInput_Version, '): ', Error);
    Halt;
  end;

  // Writeln(IVRInput^.SetActionManifestPath(PChar(StringReplace(GetCurrentDir, '\', '/', [rfReplaceAll]) + '/hellovr_actions.json')));
  // IVRInput^.GetActionHandle('/actions/demo/in/Hand_Left', @Controllers[0].ActionPose);
  // IVRInput^.GetActionHandle('/actions/demo/in/Hand_Right', @Controllers[1].ActionPose);

  IVRSystem^.GetRecommendedRenderTargetSize(@RenderWidth, @RenderHeight);
  Writeln('RenderTarget: ', RenderWidth, ' x ', RenderHeight);

  FindHmdEye(Eye_Left, EyeLeftPose, EyeLeftProj);
  FindHmdEye(Eye_Right, EyeRightPose, EyeRightProj);

  Controllers[0].Side := -1;
  Controllers[1].Side := -1;

  EyeLeftFB := CreateFrameBuffer(RenderWidth, RenderHeight);
  EyeRightFB := CreateFrameBuffer(RenderWidth, RenderHeight);
  LoadEyeMesh;
end;

procedure FreeVR;
begin
  VR_ShutdownInternal();
end;

procedure RenderVRControllers(const Pose, Proj: TMatrix4f);
var
  I: Integer;
begin
  glUseProgram(TextureShader.ProgramID);
  glUniformMatrix4fv(TextureShader.Loc[1], 1, GL_FALSE, @Pose);
  glUniformMatrix4fv(TextureShader.Loc[2], 1, GL_FALSE, @Proj);
  for I := 0 to 1 do
  begin
    if Controllers[I].Side < 0 then
      continue;
    glUniformMatrix4fv(TextureShader.Loc[0], 1, GL_FALSE, @Controllers[I].Pose);
    glBindVertexArray(Controllers[I].Mesh.VertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, Controllers[I].Mesh.Texture);
    glDrawElements(GL_TRIANGLES, Controllers[I].Mesh.VertexCount, GL_UNSIGNED_SHORT, Pointer(0));
    glBindVertexArray(0);
    glBindTexture(GL_TEXTURE_2D, 0);
  end;
  glUseProgram(0);
end;

procedure LoopVR;
var
  VRE: VREvent_t;
  I: Integer;
  IError: EVRInputError;
  State: VRControllerState_t;
  PoseData: InputPoseActionData_t;
  Controller: TController;
  Left, Right: TMatrix4f;
  CError: EVRCompositorError;
  LeftTexture,
  RightTexture: Texture_t;
begin
  // Process OpenVR events
  while IVRSystem^.PollNextEvent(@VRE, SizeOf(VRE)) do
  begin
    case EVREventType(VRE.eventType) of
      VREvent_TrackedDeviceActivated:
        Writeln('Device activated: ', vre.trackedDeviceIndex, '(', IVRSystem^.GetTrackedDeviceClass(vre.trackedDeviceIndex), ')');
      VREvent_TrackedDeviceDeactivated:
        begin
          Writeln('Device deactivated: ', vre.trackedDeviceIndex);
          if VRE.trackedDeviceIndex = Controllers[0].DeviceID then
            Controllers[0].Side := -1
          else
          if VRE.trackedDeviceIndex = Controllers[1].DeviceID then
            Controllers[1].Side := -1;
        end;
    end;
  end;
  // Process HMD position
  IVRCompositor^.WaitGetPoses(@TrackedDevicePoses, 8, nil, 0);
  for I := 0 to 7 do
  begin
    case IVRSystem^.GetTrackedDeviceClass(I) of
      TrackedDeviceClass_Controller:
        begin
          Poses[I] := ConvertVR34ToMatrix(TrackedDevicePoses[I].mDeviceToAbsoluteTracking);
          Controller := LoadOVRMesh(I);
          if Controller.Side = 0 then
            Controllers[0] := Controller
          else
          if Controller.Side = 1 then
            Controllers[1] := Controller;
        end;
      TrackedDeviceClass_HMD:
        begin
          Poses[I] := ConvertVR34ToMatrix(TrackedDevicePoses[I].mDeviceToAbsoluteTracking);
        end;
    end;
  end;
  if TrackedDevicePoses[k_unTrackedDeviceIndex_Hmd].bPoseIsValid then
  begin
    HmdPose := Inverse(Poses[k_unTrackedDeviceIndex_Hmd]);
  end;
  Left := EyeLeftPose * HmdPose;
  Right := EyeRightPose * HmdPose;
  if (Controllers[0].Side = 0) and (Controllers[0].DeviceID < k_unMaxTrackedDeviceCount) then
    Controllers[0].Pose := Poses[Controllers[0].DeviceID];
  if (Controllers[1].Side = 1) and (Controllers[1].DeviceID < k_unMaxTrackedDeviceCount) then
    Controllers[1].Pose := Poses[Controllers[1].DeviceID];
  // Render
  // Left eye
  glEnable(GL_MULTISAMPLE);
  glBindFramebuffer(GL_FRAMEBUFFER, EyeLeftFB.RenderFramebufferID);
  glViewport(0, 0, RenderWidth, RenderHeight);
  LoopRenderer(Left, EyeLeftProj);
 // RenderVRControllers(Left, EyeLeftProj);
  glDisable(GL_MULTISAMPLE);
  glBindFramebuffer(GL_READ_FRAMEBUFFER, EyeLeftFB.RenderFramebufferID);
  glBindFramebuffer(GL_DRAW_FRAMEBUFFER, EyeLeftFB.ResolveFramebufferID);
  glBlitFramebuffer(0, 0, RenderWidth, RenderHeight, 0, 0, RenderWidth, RenderHeight, GL_COLOR_BUFFER_BIT, GL_LINEAR);
  glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
  glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
  // Right eye
  glEnable(GL_MULTISAMPLE);
  glBindFramebuffer(GL_FRAMEBUFFER, EyeRightFB.RenderFramebufferID);
  glViewport(0, 0, RenderWidth, RenderHeight);
  LoopRenderer(Right, EyeRightProj);
 // RenderVRControllers(Right, EyeRightProj);
  glDisable(GL_MULTISAMPLE);
  glBindFramebuffer(GL_READ_FRAMEBUFFER, EyeRightFB.RenderFramebufferID);
  glBindFramebuffer(GL_DRAW_FRAMEBUFFER, EyeRightFB.ResolveFramebufferID);
  glBlitFramebuffer(0, 0, RenderWidth, RenderHeight, 0, 0, RenderWidth, RenderHeight, GL_COLOR_BUFFER_BIT, GL_LINEAR);
  glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);
  glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
  // Render to monitor
  glDisable(GL_DEPTH_TEST);
  glViewport(0, 0, WIDTH, HEIGHT);
  glBindVertexArray(EyeVAO);
  glUseProgram(EyeShader.ProgramID);
  glBindTexture(GL_TEXTURE_2D, EyeLeftFB.ResolveTextureID);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, Pointer(0));
  glBindTexture(GL_TEXTURE_2D, EyeRightFB.ResolveTextureID);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, Pointer(12));
  glBindTexture(GL_TEXTURE_2D, 0);
  glBindVertexArray(0);
  glUseProgram(0);
  // Submit to HMD
  LeftTexture.handle := Pointer(EyeLeftFB.ResolveTextureID);
  LeftTexture.eType := TextureType_OpenGL;
  LeftTexture.eColorSpace := ColorSpace_Gamma;
  RightTexture.handle := Pointer(EyeRightFB.ResolveTextureID);
  RightTexture.eType := TextureType_OpenGL;
  RightTexture.eColorSpace := ColorSpace_Gamma;
  CError := IVRCompositor^.Submit(Eye_Left, @LeftTexture, nil, Submit_Default);
  if CError <> VRCompositorError_None then
    Writeln('Error(Submit_Left): ', CError);
  CError := IVRCompositor^.Submit(Eye_Right, @RightTexture, nil, Submit_Default);
  if CError <> VRCompositorError_None then
    Writeln('Error(Submit_Right): ', CError);
  // Force HMD vsync
  glFinish;
  glFlush;
  glFinish;
end;

end.
