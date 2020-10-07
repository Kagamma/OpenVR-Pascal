unit Renderer;

interface

uses
  SysUtils, Classes, Math3D, GL, GLExt;

const
  Vertices: array[0..107] of GLfloat = (
    -1.0, -1.0, 1.0,
    1.0, -1.0, 1.0,
    1.0, 1.0, 1.0,
    -1.0, -1.0, 1.0,
    1.0, 1.0, 1.0,
    -1.0, 1.0, 1.0,

    1.0, -1.0, 1.0,
    1.0, -1.0, -1.0,
    1.0, 1.0, -1.0,
    1.0, -1.0, 1.0,
    1.0, 1.0, -1.0,
    1.0, 1.0, 1.0,

    1.0, -1.0, -1.0,
    -1.0, -1.0, -1.0,
    -1.0, 1.0, -1.0,
    1.0, -1.0, -1.0,
    -1.0, 1.0, -1.0,
    1.0, 1.0, -1.0,

    -1.0, -1.0, -1.0,
    -1.0, -1.0, 1.0,
    -1.0, 1.0, 1.0,
    -1.0, -1.0, -1.0,
    -1.0, 1.0, 1.0,
    -1.0, 1.0, -1.0,

    -1.0, -1.0, -1.0,
    1.0, -1.0, -1.0,
    1.0, -1.0, 1.0,
    -1.0, -1.0, -1.0,
    1.0, -1.0, 1.0,
    -1.0, -1.0, 1.0,

    -1.0, 1.0, 1.0,
    1.0, 1.0, 1.0,
    1.0, 1.0, -1.0,
    -1.0, 1.0, 1.0,
    1.0, 1.0, -1.0,
    -1.0, 1.0, -1.0
  );
  Normals: array[0..107] of GLfloat = (
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,

    1, 0, 0,
    1, 0, 0,
    1, 0, 0,
    1, 0, 0,
    1, 0, 0,
    1, 0, 0,

    0, 0, -1,
    0, 0, -1,
    0, 0, -1,
    0, 0, -1,
    0, 0, -1,
    0, 0, -1,

    -1, 0, 0,
    -1, 0, 0,
    -1, 0, 0,
    -1, 0, 0,
    -1, 0, 0,
    -1, 0, 0,

    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,

    0, 1, 0,
    0, 1, 0,
    0, 1, 0,
    0, 1, 0,
    0, 1, 0,
    0, 1, 0
  );
  CMIN = -3;
  CMAX = 3;

type
  TShader = record
    VertexID,
    FragmentID,
    ProgramID: GLuint;
    Loc: array[0..9] of GLuint;
  end;

procedure InitRenderer;
procedure FreeRenderer;
procedure LoopRenderer(const View, Proj: TMatrix4f);

var
  EyeShader,
  TextureShader,
  FlatShader: TShader;
  VertexArray,
  VertexBuffer,
  NormalBuffer: GLuint;
  ColorArray: array [CMIN..CMAX,CMIN..CMAX,CMIN..CMAX] of TVector3f;

implementation

uses
  VR;

var
  BaseA: Single;

procedure InitRenderer;
  function LoadShader(Kind: GLuint; Name: String): GLuint;
  var
    SL: TStringList;
    Code: PGLchar;
    Status: GLint = GL_FALSE;
    Len: GLint;
    ErrorMsg: array of GLchar;
    I: Integer;
  begin
    SL := TStringList.Create;
    try
      SL.LoadFromFile(Name);
      Code := PChar(SL.Text);
      Result := glCreateShader(Kind);
      glShaderSource(Result, 1, @Code, nil);
      glCompileShader(Result);
      glGetShaderiv(Result, GL_COMPILE_STATUS, @Status);
      glGetShaderiv(Result, GL_INFO_LOG_LENGTH, @Len);
      if Status = GL_FALSE then
      begin
        Writeln('Compile "', Name,'" failed!');
        SetLength(ErrorMsg, Len + 1);
        glGetShaderInfoLog(Result, Len, nil, @ErrorMsg[0]);
        for I := 0 to Len do
          Write(String(ErrorMsg[I]));
        Writeln;
      end else
        Writeln('Compile "', Name,'" success!' );
    finally
      FreeAndNil(SL);
    end;
  end;

  function CreateShaderProgram(VertName, FragName: String): TShader;
  begin
    Result.VertexID := LoadShader(GL_VERTEX_SHADER, VertName);
    Result.FragmentID := LoadShader(GL_FRAGMENT_SHADER, FragName);
    Result.ProgramID := glCreateProgram();
    glAttachShader(Result.ProgramID, Result.VertexID);
    glAttachShader(Result.ProgramID, Result.FragmentID);
    glLinkProgram(Result.ProgramID);
  end;

var
  I, J, K: Integer;

begin
  glClearColor(0, 0, 0.2, 1);
  FlatShader := CreateShaderProgram('shaders/flat.vert', 'shaders/flat.frag');
  FlatShader.Loc[0] := glGetUniformLocation(FlatShader.ProgramID, 'modelMatrix');
  FlatShader.Loc[1] := glGetUniformLocation(FlatShader.ProgramID, 'viewMatrix');
  FlatShader.Loc[2] := glGetUniformLocation(FlatShader.ProgramID, 'projMatrix');
  FlatShader.Loc[3] := glGetUniformLocation(FlatShader.ProgramID, 'color');
  EyeShader := CreateShaderProgram('shaders/eye.vert', 'shaders/eye.frag');
  TextureShader := CreateShaderProgram('shaders/texture.vert', 'shaders/texture.frag');
  TextureShader.Loc[0] := glGetUniformLocation(TextureShader.ProgramID, 'modelMatrix');
  TextureShader.Loc[1] := glGetUniformLocation(TextureShader.ProgramID, 'viewMatrix');
  TextureShader.Loc[2] := glGetUniformLocation(TextureShader.ProgramID, 'projMatrix');

  glGenVertexArrays(1, @VertexArray);

  glGenBuffers(1, @VertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, VertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, Sizeof(Vertices), @Vertices, GL_STATIC_DRAW);
  glGenBuffers(1, @NormalBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, NormalBuffer);
  glBufferData(GL_ARRAY_BUFFER, Sizeof(Normals), @Normals, GL_STATIC_DRAW);

  glBindVertexArray(VertexArray);
  glBindBuffer(GL_ARRAY_BUFFER, VertexBuffer);
  glEnableVertexAttribArray(0);
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, Pointer(0));
  glBindBuffer(GL_ARRAY_BUFFER, NormalBuffer);
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, Pointer(0));

  glBindVertexArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, 0);

  for K := CMIN to CMAX do
    for J := CMIN to CMAX do
      for I := CMIN to CMAX do
        ColorArray[K,J,I] := Vector(Random, Random, Random);
end;

procedure FreeRenderer;
begin
end;

procedure LoopRenderer(const View, Proj: TMatrix4f);
var
  T, R, S, M: TMatrix4f;
  I, J, K: Integer;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glEnable(GL_DEPTH_TEST);

  glUseProgram(FlatShader.ProgramID);
  glUniformMatrix4fv(FlatShader.Loc[1], 1, GL_FALSE, @View);
  glUniformMatrix4fv(FlatShader.Loc[2], 1, GL_FALSE, @Proj);
  glBindVertexArray(VertexArray);
  CreateRotate(R, Vector(0, BaseA, 0));
  for K := CMIN to CMAX do
    for J := CMIN to CMAX do
      for I := CMIN to CMAX do
      begin
        CreateTranslate(T, Vector(I * 5, J * 5, K * 5));
        Scale(S, 0.05);
        M := S * T * R;
        glUniformMatrix4fv(FlatShader.Loc[0], 1, GL_FALSE, @M);
        glUniform3fv(FlatShader.Loc[3], 1, @ColorArray[K,J,I]);
        glDrawArrays(GL_TRIANGLES, 0, Length(Vertices) div 3);
      end;
  glBindVertexArray(0);
  glUseProgram(0);

  BaseA := BaseA + 0.005;
end;

end.