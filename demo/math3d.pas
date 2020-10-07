unit Math3D;

{$mode objfpc}

interface

uses
  Math;

const
  DEG2RAD: Single = 0.0174532925199433;
  RAD2DEG: Single = 57.295779513082321;

type
  PVector3f = ^TVector3f;
  TVector3f = packed record
    X, Y, Z: Single;
  end;

  PVector4f = ^TVector4f;
  TVector4f = packed record
    X, Y, Z, W: Single;
  end;

  TMatrix4f   = array [0..3, 0..3] of Single;
  PMatrix4f   = ^TMatrix4f;
  TMatrix3f   = array [0..2, 0..2] of Single;
  PMatrix3f   = ^TMatrix3f;

var
  ZeroVector3f: TVector3f = (X:0; Y:0; Z:0);
  ZeroVector4f: TVector4f = (X:0; Y:0; Z:0; W:0);
  XVector3f   : TVector3f = (X:1; Y:0; Z:0);
  YVector3f   : TVector3f = (X:0; Y:1; Z:0);
  ZVector3f   : TVector3f = (X:0; Y:0; Z:1);

  XVector4f   : TVector4f = (X:1; Y:0; Z:0; W:0);
  YVector4f   : TVector4f = (X:0; Y:1; Z:0; W:0);
  ZVector4f   : TVector4f = (X:0; Y:0; Z:1; W:0);
  WVector4f   : TVector4f = (X:0; Y:0; Z:0; W:1);
  Identity4f  : TMatrix4f = ((1, 0, 0, 0),
                             (0, 1, 0, 0),
                             (0, 0, 1, 0),
                             (0, 0, 0, 1));
  Identity3f  : TMatrix3f = ((1, 0, 0),
                             (0, 1, 0),
                             (0, 0, 1));

function  Vector(const X, Y, Z: Single): TVector3f; overload;
function  Vector(const X, Y, Z, W: Single): TVector4f; overload;

function  Clamp(const aValue, aMin, aMax: Single): Single;
function  RoundOff(const X: Single): Single;

function  AngleNormalize(const Angle: Single): Single;
function  Angle(const PX1, py1, PX2, py2: Single): Single; overload;
function  Angle(const V1, V2: TVector3f): Single; overload;
function  Lerp(const Start, Stop, t: Single): Single; overload;
function  AngleLerp(Start, Stop, t: Single): Single;

// vector3f

procedure Zero(var V: TVector3f); overload;
function  Add(const V1, V2: TVector3f): TVector3f; overload;
function  Sub(const V1, V2: TVector3f): TVector3f; overload;
function  Cross(const V1, V2: TVector3f): TVector3f;
procedure Normalize(var vNormal: TVector3f); overload;
function  Distance(const V1, V2: TVector3f): Single;
function  Dot(const V1, V2: TVector3f): Single; overload;
procedure Combine(var V1: TVector3f; const V2: TVector3f; const F: PSingle); overload;
function  Magnitude(const V: TVector3f): Single; overload;
function  Lerp(const V1, V2: TVector3f; T: Single): TVector3f; overload;
function  Scale(const V: TVector3f; S: Single): TVector3f; overload;
function  Rotate(const vA: TVector3f; const Angle: Single; axis: TVector3f): TVector3f; overload;

// vector4f

procedure Zero(var V: TVector4f); overload;
function  Add(const V1, V2: TVector4f): TVector4f; overload;
function  Sub(const V1, V2: TVector4f): TVector4f; overload;
procedure Combine(var V1: TVector4f; const V2: TVector4f; const F: PSingle); overload;
function  Dot(const V1, V2: TVector4f): Single; overload;
function  Scale(const V: TVector4f; S: Single): TVector4f; overload;
procedure Normalize(var vNormal: TVector4f); overload;
function  Lerp(const V1, V2: TVector4f; T: Single): TVector4f; overload;

// matrix3f

function  Mult(const M1, M2: TMatrix3f): TMatrix3f; overload;
function  Transpose(const M: TMatrix3f): TMatrix3f; overload;
function  Inverse(const M: TMatrix3f): TMatrix3f; overload;

// matrix4f

function  Mult(const M1, M2: TMatrix4f): TMatrix4f; overload;
function  Mult(const M: TMatrix4f; const v: TVector3f): TVector3f; overload;
function  MultRotate(const M: TMatrix4f; const V: TVector3f): TVector3f;
function  Mult(const M: TMatrix4f; const v: TVector4f): TVector4f; overload;
procedure Create(out M: TMatrix4f; const X, Y, Z: TVector3f); overload;
procedure CreateTranslate(out M: TMatrix4f; const p: TVector3f); overload;
function  CreateTranslate(const p: TVector3f): TMatrix4f; overload;
procedure CreateRotate(out M: TMatrix4f; const p: TVector3f);
function  GetAngle(const M: TMatrix4f; const axis: LongInt): Single;
function  Inverse(const M: TMatrix4f): TMatrix4f; overload;
function  Transpose(const M: TMatrix4f): TMatrix4f; overload;
procedure Translate(var M: TMatrix4f; const V: TVector3f); overload;
procedure Translate(var M: TMatrix4f; const X, Y, Z: Single); overload;
procedure Scale(var M: TMatrix4f; const s: Single); overload;
procedure Scale(var M: TMatrix4f; const x, y, z: Single); overload;
procedure Scale(var M: TMatrix4f; const v: TVector3f); overload;
function  LookAt(const eye, target, up: TVector3f): TMatrix4f; overload;
procedure LookAt(out M: TMatrix4f; const eye, target, up: TVector3f); overload;
procedure Rotate(var M: TMatrix4f; const A, X, Y, Z: Single); overload;
procedure Rotate(var M: TMatrix4f; const p: TVector3f); overload;
function  GetTranslate(const M: TMatrix4f): TVector3f;
procedure GetRotate(out M2: TMatrix4f; const M: TMatrix4f); overload;
procedure GetRotate(out M2: TMatrix3f; const M: TMatrix4f); overload;
function  GetRotate(const M: TMatrix4f): TMatrix3f; overload;
procedure Ortho(out M: TMatrix4f; const vleft, vright, vbottom, vtop, vnear, vfar: Single);
procedure Frustum(out M: TMatrix4f; const vleft, vright, vbottom, vtop, vnear, vfar: Single);
procedure Perspective(out M: TMatrix4f; const FOVY, aspect, vnear, vfar: Single);

// vector3f

operator =  (V1, V2: TVector3f): Boolean;
operator +  (V1, V2: TVector3f): TVector3f;
operator -  (V: TVector3f): TVector3f;
operator -  (V1, V2: TVector3f): TVector3f;
operator *  (V: TVector3f; S: Single): TVector3f;
operator *  (S: Single; V: TVector3f): TVector3f;
operator := (V: TVector3f): Single;

// vector4f

operator +  (V1, V2: TVector4f): TVector4f;
operator -  (V1, V2: TVector4f): TVector4f;
operator *  (V1, V2: TVector4f): Single;
operator *  (V: TVector4f; S: Single): TVector4f;
operator *  (S: Single; V: TVector4f): TVector4f;

// matrix 3f

operator *  (M1, M2: TMatrix3f): TMatrix3f;

// matrix 4f

operator := (M: TMatrix4f): TMatrix3f;
operator *  (M1, M2: TMatrix4f): TMatrix4f;
operator *  (M: TMatrix4f; S: Single): TMatrix4f;
operator *  (M: TMatrix4f; V: TVector3f): TVector3f;
operator *  (V: TVector3f; M: TMatrix4f): TVector3f;
operator +  (M: TMatrix4f; V: TVector3f): TMatrix4f;

implementation

// misc

function  Vector(const X, Y, Z: Single): TVector3f; overload;
begin
  Result.X:= X;
  Result.Y:= Y;
  Result.Z:= Z;
end;

function  Vector(const X, Y, Z, W: Single): TVector4f; overload;
begin
  Result.X:= X;
  Result.Y:= Y;
  Result.Z:= Z;
  Result.W:= W;
end;

function  Clamp(const aValue, aMin, aMax: Single): Single;
begin
  if aValue<aMin then
    Result:= aMin
  else
  if aValue>aMax then
    Result:= aMax
  else
    Result:= aValue;
end;

function  RoundOff(const X: Single): Single;
begin
  if (X < 0.0001) AND (X > -0.0001) then
    Result:= 0.0
  else
    Result:= X;
end;

function  Angle(const PX1, py1, PX2, py2: Single): Single;
begin
  Result:= Arctan2(py2-py1, PX2-PX1);
  if Result<0 then
    Result:= Result + PI*2;
end;

function  Angle(const V1, V2: TVector3f): Single;
var D, L : Single;
    A: Single;
begin
  D:= Dot(V1, V2);
  L:= Magnitude(V1) * Magnitude(V2);
  A:= Arccos(D / L);
  if IsNan(A) then
    Result:= 0
  else
    Result:= A;
end;

function  AngleNormalize(const Angle: Single): Single;
begin
  Result:= Angle-Int(Angle/6.283185307)*6.283185307;
  if Result>PI then
    Result:= Result-2*PI
  else
  if Result<-PI then
    Result:= Result+2*PI;
end;

function  Lerp(const Start, Stop, t : Single) : Single;
begin
  Result:= Start+(Stop-Start)*t;
end;

function  AngleLerp(Start, Stop, t : Single) : Single;
var
   d : Single;
begin
  Start:= AngleNormalize(Start);
  Stop := AngleNormalize(Stop);
  d:= Stop-Start;
  if d>PI then
    d:= -d-6.283185307
  else
  if d< -PI then
    d:= d+6.283185307;
  Result:= Start+d*t;
end;

// vector3f

procedure Zero(var V: TVector3f);
begin
  V.X:= ZeroVector3f;
end;

function  Add(const V1, V2: TVector3f): TVector3f;
begin
  Result.X:= V1.X+V2.X;
  Result.Y:= V1.Y+V2.Y;
  Result.Z:= V1.Z+V2.Z;
end;

function  Sub(const V1, V2: TVector3f): TVector3f;
begin
  Result.X:= V1.X-V2.X;
  Result.Y:= V1.Y-V2.Y;
  Result.Z:= V1.Z-V2.Z;
end;

function  Cross(const V1, V2: TVector3f): TVector3f;
begin
  Result.X:= (V1.Y * V2.Z) - (V1.Z * V2.Y);
  Result.Y:= (V1.Z * V2.X) - (V1.X * V2.Z);
  Result.Z:= (V1.X * V2.Y) - (V1.Y * V2.X);
end;

procedure Normalize(var vNormal: TVector3f);
var
  invLen: Single;
  tmp   : single;
begin
  tmp:= vNormal.X*vNormal.X+vNormal.Y*vNormal.Y+vNormal.Z*vNormal.Z;
  if tmp>0 then
  begin
    invLen:= Sqrt(tmp);
    vNormal.X:= vNormal.X/invLen;
    vNormal.Y:= vNormal.Y/invLen;
    vNormal.Z:= vNormal.Z/invLen;
  end;
end;

function  Distance(const V1, V2: TVector3f): Single;
begin
  Result:= Sqrt((V2.X - V1.X) * (V2.X - V1.X) +
	        (V2.Y - V1.Y) * (V2.Y - V1.Y) +
	        (V2.Z - V1.Z) * (V2.Z - V1.Z));
end;

function  Dot(const V1, V2: TVector3f): Single;
begin
  Result:= (V1.X * V2.X) +
           (V1.Y * V2.Y) +
           (V1.Z * V2.Z);
end;

procedure Combine(var V1: TVector3f; const V2: TVector3f; const F: PSingle);
begin
  V1.x:= V1.X + (F^*V2.X);
  V1.y:= V1.Y + (F^*V2.Y);
  V1.z:= V1.Z + (F^*V2.Z);
end;

function  PointProject(const p, origin, direction: TVector3f): Single;
begin
  Result:= direction.X*(p.x-origin.X) +
           direction.Y*(p.y-origin.Y) +
           direction.Z*(p.z-origin.Z);
end;

function  Magnitude(const V: TVector3f): Single;
begin
  Result:= Sqrt(V.X*V.X + V.Y*V.Y + V.Z*V.Z);
end;

function  Scale(const V: TVector3f; S: Single): TVector3f;
begin
  Result.X:= V.X*S;
  Result.Y:= V.Y*S;
  Result.Z:= V.Z*S;
end;

function  Lerp(const V1, V2: TVector3f; T: Single): TVector3f;
begin
  Result.X:= V1.X+(V2.X-V1.X)*T;
  Result.Y:= V1.Y+(V2.Y-V1.Y)*T;
  Result.Z:= V1.Z+(V2.Z-V1.Z)*T;
end;

function  Rotate(const vA: TVector3f; const Angle: Single; axis: TVector3f): TVector3f; overload;
var vCos, vSin, PX, py, pz: Single;
begin
  if Angle=0 then
  begin
    Result:= vA;
    exit;
  end;
  Normalize(axis);
  PX:= vA.x; py:= vA.y; pz:= vA.z;
  vCos:= Cos(Angle);
  vSin:= Sin(Angle);
  Result.x:= PX*( axis.x*axis.x * ( 1.0 - vCos ) + vCos) +
             py*( axis.x*axis.y * ( 1.0 - vCos ) - axis.z * vSin) +
             pz*( axis.x*axis.z * ( 1.0 - vCos ) + axis.y * vSin);
  Result.y:= PX*( axis.y*axis.x * ( 1.0 - vCos ) + axis.z * vSin) +
             py*( axis.y*axis.y * ( 1.0 - vCos ) + vCos) +
             pz*( axis.y*axis.z * ( 1.0 - vCos ) - axis.x * vSin);
  Result.z:= PX*( axis.z*axis.x * ( 1.0 - vCos ) - axis.y * vSin) +
             py*( axis.z*axis.y * ( 1.0 - vCos ) + axis.x * vSin) +
             pz*( axis.z*axis.z * ( 1.0 - vCos ) + vCos);
end;

// vector4f / Plane / quat

procedure Zero(var V: TVector4f);
begin
  V := ZeroVector4f;
end;

function  Add(const V1, V2: TVector4f): TVector4f;
begin
  Result.X:= V1.X + V2.X;
  Result.Y:= V1.Y + V2.Y;
  Result.Z:= V1.Z + V2.Z;
  Result.W:= V1.W + V2.W;
end;

function  Sub(const V1, V2: TVector4f): TVector4f;
begin
  Result.X:= V1.X - V2.X;
  Result.Y:= V1.Y - V2.Y;
  Result.Z:= V1.Z - V2.Z;
  Result.W:= V1.W - V2.W;
end;

procedure Normalize(var vNormal: TVector4f);
var
  invLen: Single;
  vn    : single;
begin
  vn:= vNormal.X*vNormal.X+vNormal.Y*vNormal.Y+vNormal.Z*vNormal.Z+vNormal.W*vNormal.W;
  if vn>0 then
  begin
    invLen:= Sqrt(vn);
    vNormal.X:= vNormal.X/invLen;
    vNormal.Y:= vNormal.Y/invLen;
    vNormal.Z:= vNormal.Z/invLen;
    vNormal.W:= vNormal.W/invLen;
  end;
end;

function  Dot(const V1, V2: TVector4f): Single;
begin
  Result:= (V1.X * V2.X) +
           (V1.Y * V2.Y) +
           (V1.Z * V2.Z) +
           (V1.W * V2.W);
end;

procedure Combine(var V1: TVector4f; const V2: TVector4f; const F: PSingle);
begin
  V1.X:= V1.X + (F^*V2.X);
  V1.Y:= V1.Y + (F^*V2.Y);
  V1.Z:= V1.Z + (F^*V2.Z);
  V1.W:= V1.W + (F^*V2.W);
end;

function  Scale(const V: TVector4f; S: Single): TVector4f;
begin
  Result.X:= V.X*S;
  Result.Y:= V.Y*S;
  Result.Z:= V.Z*S;
  Result.W:= V.W*S;
end;

function  Lerp(const V1, V2: TVector4f; T: Single): TVector4f;
begin
   Result.X:= V1.X+(V2.X-V1.X)*T;
   Result.Y:= V1.Y+(V2.Y-V1.Y)*T;
   Result.Z:= V1.Z+(V2.Z-V1.Z)*T;
   Result.W:= V1.W+(V2.W-V1.W)*T;
end;

// matrix 3f

function  Transpose(const M: TMatrix3f): TMatrix3f;
begin
  Result[0,0] := M[0,0]; Result[0,1] := M[1,0]; Result[0,2] := M[2,0];
  Result[1,0] := M[0,1]; Result[1,1] := M[1,1]; Result[1,2] := M[2,1];
  Result[2,0] := M[0,2]; Result[2,1] := M[1,2]; Result[2,2] := M[2,2];
end;

function  Mult(const M1, M2: TMatrix3f): TMatrix3f;
begin
  Result[0,0]:= M1[0,0]*M2[0,0]+M1[0,1]*M2[1,0]+M1[0,2]*M2[2,0];
  Result[0,1]:= M1[0,0]*M2[0,1]+M1[0,1]*M2[1,1]+M1[0,2]*M2[2,1];
  Result[0,2]:= M1[0,0]*M2[0,2]+M1[0,1]*M2[1,2]+M1[0,2]*M2[2,2];
  Result[1,0]:= M1[1,0]*M2[0,0]+M1[1,1]*M2[1,0]+M1[1,2]*M2[2,0];
  Result[1,1]:= M1[1,0]*M2[0,1]+M1[1,1]*M2[1,1]+M1[1,2]*M2[2,1];
  Result[1,2]:= M1[1,0]*M2[0,2]+M1[1,1]*M2[1,2]+M1[1,2]*M2[2,2];
  Result[2,0]:= M1[2,0]*M2[0,0]+M1[2,1]*M2[1,0]+M1[2,2]*M2[2,0];
  Result[2,1]:= M1[2,0]*M2[0,1]+M1[2,1]*M2[1,1]+M1[2,2]*M2[2,1];
  Result[2,2]:= M1[2,0]*M2[0,2]+M1[2,1]*M2[1,2]+M1[2,2]*M2[2,2];
end;

function  Inverse(const M: TMatrix3f): TMatrix3f;
var
  a00, a01, a02, a10, a11, a12, a20, a21, a22, b01, b11, b21, d: Single;
begin
  a00:= M[0,0]; a01:= M[0,1]; a02:= M[0,2];
  a10:= M[1,0]; a11:= M[1,1]; a12:= M[1,2];
  a20:= M[2,0]; a21:= M[2,1]; a22:= M[2,2];

  b01:= a22*a11-a12*a21;
  b11:=-a22*a10+a12*a20;
  b21:= a21*a10-a11*a20;

  d:= a00*b01 + a01*b11 + a02*b21;
  if Abs(d)<1e-40 then
  begin
    Result:= Identity3f;
    exit;
  end;
  d:= 1/d;

  Result[0,0]:= b01*d;
  Result[0,1]:= (-a22*a01 + a02*a21)*d;
  Result[0,2]:= (a12*a01 - a02*a11)*d;
  Result[1,0]:= b11*d;
  Result[1,1]:= (a22*a00 - a02*a20)*d;
  Result[1,2]:= (-a12*a00 + a02*a10)*d;
  Result[2,0]:= b21*d;
  Result[2,1]:= (-a21*a00 + a01*a20)*d;
  Result[2,2]:= (a11*a00 - a01*a10)*d;
end;

// matrix 4f

function  Mult(const M1, M2: TMatrix4f): TMatrix4f;
begin
  Result[0,0]:= M1[0,0]*M2[0,0]+M1[0,1]*M2[1,0]+M1[0,2]*M2[2,0]+M1[0,3]*M2[3,0];
  Result[0,1]:= M1[0,0]*M2[0,1]+M1[0,1]*M2[1,1]+M1[0,2]*M2[2,1]+M1[0,3]*M2[3,1];
  Result[0,2]:= M1[0,0]*M2[0,2]+M1[0,1]*M2[1,2]+M1[0,2]*M2[2,2]+M1[0,3]*M2[3,2];
  Result[0,3]:= M1[0,0]*M2[0,3]+M1[0,1]*M2[1,3]+M1[0,2]*M2[2,3]+M1[0,3]*M2[3,3];
  Result[1,0]:= M1[1,0]*M2[0,0]+M1[1,1]*M2[1,0]+M1[1,2]*M2[2,0]+M1[1,3]*M2[3,0];
  Result[1,1]:= M1[1,0]*M2[0,1]+M1[1,1]*M2[1,1]+M1[1,2]*M2[2,1]+M1[1,3]*M2[3,1];
  Result[1,2]:= M1[1,0]*M2[0,2]+M1[1,1]*M2[1,2]+M1[1,2]*M2[2,2]+M1[1,3]*M2[3,2];
  Result[1,3]:= M1[1,0]*M2[0,3]+M1[1,1]*M2[1,3]+M1[1,2]*M2[2,3]+M1[1,3]*M2[3,3];
  Result[2,0]:= M1[2,0]*M2[0,0]+M1[2,1]*M2[1,0]+M1[2,2]*M2[2,0]+M1[2,3]*M2[3,0];
  Result[2,1]:= M1[2,0]*M2[0,1]+M1[2,1]*M2[1,1]+M1[2,2]*M2[2,1]+M1[2,3]*M2[3,1];
  Result[2,2]:= M1[2,0]*M2[0,2]+M1[2,1]*M2[1,2]+M1[2,2]*M2[2,2]+M1[2,3]*M2[3,2];
  Result[2,3]:= M1[2,0]*M2[0,3]+M1[2,1]*M2[1,3]+M1[2,2]*M2[2,3]+M1[2,3]*M2[3,3];
  Result[3,0]:= M1[3,0]*M2[0,0]+M1[3,1]*M2[1,0]+M1[3,2]*M2[2,0]+M1[3,3]*M2[3,0];
  Result[3,1]:= M1[3,0]*M2[0,1]+M1[3,1]*M2[1,1]+M1[3,2]*M2[2,1]+M1[3,3]*M2[3,1];
  Result[3,2]:= M1[3,0]*M2[0,2]+M1[3,1]*M2[1,2]+M1[3,2]*M2[2,2]+M1[3,3]*M2[3,2];
  Result[3,3]:= M1[3,0]*M2[0,3]+M1[3,1]*M2[1,3]+M1[3,2]*M2[2,3]+M1[3,3]*M2[3,3];
end;

function  Mult(const M: TMatrix4f; const v: TVector3f): TVector3f;
begin
  Result.X:= v.X * M[0,0] + v.Y * M[1,0] + v.Z * M[2,0] + M[3,0];
  Result.Y:= v.X * M[0,1] + v.Y * M[1,1] + v.Z * M[2,1] + M[3,1];
  Result.Z:= v.X * M[0,2] + v.Y * M[1,2] + v.Z * M[2,2] + M[3,2];
end;

function  MultRotate(const M: TMatrix4f; const V: TVector3f): TVector3f;
begin
  Result.X:= V.X*M[0,0] + V.Y*M[1,0] + V.Z*M[2,0];
  Result.Y:= V.X*M[0,1] + V.Y*M[1,1] + V.Z*M[2,1];
  Result.Z:= V.X*M[0,2] + V.Y*M[1,2] + V.Z*M[2,2];
end;

function  Mult(const M: TMatrix4f; const v: TVector4f): TVector4f;
begin
  Result.X:= v.X * M[0,0] + v.Y * M[1,0] + v.Z * M[2,0] + v.W * M[3,0];
  Result.Y:= v.X * M[0,1] + v.Y * M[1,1] + v.Z * M[2,1] + v.W * M[3,1];
  Result.Z:= v.X * M[0,2] + v.Y * M[1,2] + v.Z * M[2,2] + v.W * M[3,2];
  Result.W:= v.X * M[0,3] + v.Y * M[1,3] + v.Z * M[2,3] + v.W * M[3,3];
end;

procedure Create(out M: TMatrix4f; const X, Y, Z: TVector3f); overload;
begin
  M[0,0]:= X.X; M[0,1]:= X.Y; M[0,2]:= X.Z; M[0,3]:= 0;
  M[1,0]:= Y.X; M[1,1]:= Y.Y; M[1,2]:= Y.Z; M[1,3]:= 0;
  M[2,0]:= Z.X; M[2,1]:= Z.Y; M[2,2]:= Z.Z; M[2,3]:= 0;
  M[3,0]:= 0;   M[3,1]:= 0;   M[3,2]:= 0;   M[3,3]:= 1;
end;

procedure CreateTranslate(out M: TMatrix4f; const p: TVector3f);
begin
  M[0,0]:= 1;   M[0,1]:= 0;   M[0,2]:= 0;   M[0,3]:= 0;
  M[1,0]:= 0;   M[1,1]:= 1;   M[1,2]:= 0;   M[1,3]:= 0;
  M[2,0]:= 0;   M[2,1]:= 0;   M[2,2]:= 1;   M[2,3]:= 0;
  M[3,0]:= p.X; M[3,1]:= p.Y; M[3,2]:= p.Z; M[3,3]:= 1;
end;

function  CreateTranslate(const p: TVector3f): TMatrix4f;
begin
  Result[0,0]:= 1;   Result[0,1]:= 0;   Result[0,2]:= 0;   Result[0,3]:= 0;
  Result[1,0]:= 0;   Result[1,1]:= 1;   Result[1,2]:= 0;   Result[1,3]:= 0;
  Result[2,0]:= 0;   Result[2,1]:= 0;   Result[2,2]:= 1;   Result[2,3]:= 0;
  Result[3,0]:= p.X; Result[3,1]:= p.Y; Result[3,2]:= p.Z; Result[3,3]:= 1;
end;

procedure CreateRotate(out M: TMatrix4f; const p: TVector3f);
var
  cr, cp, cy, sr, sp, sy: Single;
begin
  cr:= cos(p.X);
  sr:= sin(p.X);
  cp:= cos(p.Y);
  sp:= sin(p.Y);
  cy:= cos(p.Z);
  sy:= sin(p.Z);
  M[0,0]:= cp * cy;
  M[0,1]:= cp * sy;
  M[0,2]:= - sp;
  M[0,3]:= 0;
  M[1,0]:= sr * sp * cy - cr * sy;
  M[1,1]:= sr * sp * sy + cr * cy;
  M[1,2]:= sr * cp;
  M[1,3]:= 0;
  M[2,0]:= cr * sp * cy + sr * sy;
  M[2,1]:= cr * sp * sy - sr * cy;
  M[2,2]:= cr * cp;
  M[2,3]:= 0;
  M[3,0]:= 0;
  M[3,1]:= 0;
  M[3,2]:= 0;
  M[3,3]:= 1;
end;

function  GetAngle(const M: TMatrix4f; const axis: LongInt): Single;
begin
  case axis of
    0: Result:= Angle(0, 0, M[0,0], M[0,2]);
    1: Result:= Angle(0, 0, M[2,2], M[2,1]);
    else
      Result := Angle(0, 0, M[0,0], M[0,1]);
  end;
end;

function  Inverse(const M: TMatrix4f): TMatrix4f;
var
  i, j: Cardinal;
  det : Single;
  inv : TMatrix4f;
begin
  inv[0,0]:=  M[1,1] * M[2,2] * M[3,3] -
              M[1,1] * M[2,3] * M[3,2] -
              M[2,1] * M[1,2] * M[3,3] +
              M[2,1] * M[1,3] * M[3,2] +
              M[3,1] * M[1,2] * M[2,3] -
              M[3,1] * M[1,3] * M[2,2];

  inv[1,0]:= -M[1,0] * M[2,2] * M[3,3] +
              M[1,0] * M[2,3] * M[3,2] +
              M[2,0] * M[1,2] * M[3,3] -
              M[2,0] * M[1,3] * M[3,2] -
              M[3,0] * M[1,2] * M[2,3] +
              M[3,0] * M[1,3] * M[2,2];

  inv[2,0]:=  M[1,0] * M[2,1] * M[3,3] -
              M[1,0] * M[2,3] * M[3,1] -
              M[2,0] * M[1,1] * M[3,3] +
              M[2,0] * M[1,3] * M[3,1] +
              M[3,0] * M[1,1] * M[2,3] -
              M[3,0] * M[1,3] * M[2,1];

  inv[3,0]:= -M[1,0] * M[2,1] * M[3,2] +
              M[1,0] * M[2,2] * M[3,1] +
              M[2,0] * M[1,1] * M[3,2] -
              M[2,0] * M[1,2] * M[3,1] -
              M[3,0] * M[1,1] * M[2,2] +
              M[3,0] * M[1,2] * M[2,1];

  inv[0,1]:= -M[0,1] * M[2,2] * M[3,3] +
              M[0,1] * M[2,3] * M[3,2] +
              M[2,1] * M[0,2] * M[3,3] -
              M[2,1] * M[0,3] * M[3,2] -
              M[3,1] * M[0,2] * M[2,3] +
              M[3,1] * M[0,3] * M[2,2];

  inv[1,1]:=  M[0,0] * M[2,2] * M[3,3] -
              M[0,0] * M[2,3] * M[3,2] -
              M[2,0] * M[0,2] * M[3,3] +
              M[2,0] * M[0,3] * M[3,2] +
              M[3,0] * M[0,2] * M[2,3] -
              M[3,0] * M[0,3] * M[2,2];

  inv[2,1]:= -M[0,0] * M[2,1] * M[3,3] +
              M[0,0] * M[2,3] * M[3,1] +
              M[2,0] * M[0,1] * M[3,3] -
              M[2,0] * M[0,3] * M[3,1] -
              M[3,0] * M[0,1] * M[2,3] +
              M[3,0] * M[0,3] * M[2,1];

  inv[3,1]:=  M[0,0] * M[2,1] * M[3,2] -
              M[0,0] * M[2,2] * M[3,1] -
              M[2,0] * M[0,1] * M[3,2] +
              M[2,0] * M[0,2] * M[3,1] +
              M[3,0] * M[0,1] * M[2,2] -
              M[3,0] * M[0,2] * M[2,1];

  inv[0,2]:=  M[0,1] * M[1,2] * M[3,3] -
              M[0,1] * M[1,3] * M[3,2] -
              M[1,1] * M[0,2] * M[3,3] +
              M[1,1] * M[0,3] * M[3,2] +
              M[3,1] * M[0,2] * M[1,3] -
              M[3,1] * M[0,3] * M[1,2];

  inv[1,2]:= -M[0,0] * M[1,2] * M[3,3] +
              M[0,0] * M[1,3] * M[3,2] +
              M[1,0] * M[0,2] * M[3,3] -
              M[1,0] * M[0,3] * M[3,2] -
              M[3,0] * M[0,2] * M[1,3] +
              M[3,0] * M[0,3] * M[1,2];

  inv[2,2]:=  M[0,0] * M[1,1] * M[3,3] -
              M[0,0] * M[1,3] * M[3,1] -
              M[1,0] * M[0,1] * M[3,3] +
              M[1,0] * M[0,3] * M[3,1] +
              M[3,0] * M[0,1] * M[1,3] -
              M[3,0] * M[0,3] * M[1,1];

  inv[3,2]:= -M[0,0] * M[1,1] * M[3,2] +
              M[0,0] * M[1,2] * M[3,1] +
              M[1,0] * M[0,1] * M[3,2] -
              M[1,0] * M[0,2] * M[3,1] -
              M[3,0] * M[0,1] * M[1,2] +
              M[3,0] * M[0,2] * M[1,1];

  inv[0,3]:= -M[0,1] * M[1,2] * M[2,3] +
              M[0,1] * M[1,3] * M[2,2] +
              M[1,1] * M[0,2] * M[2,3] -
              M[1,1] * M[0,3] * M[2,2] -
              M[2,1] * M[0,2] * M[1,3] +
              M[2,1] * M[0,3] * M[1,2];

  inv[1,3]:=  M[0,0] * M[1,2] * M[2,3] -
              M[0,0] * M[1,3] * M[2,2] -
              M[1,0] * M[0,2] * M[2,3] +
              M[1,0] * M[0,3] * M[2,2] +
              M[2,0] * M[0,2] * M[1,3] -
              M[2,0] * M[0,3] * M[1,2];

  inv[2,3]:= -M[0,0] * M[1,1] * M[2,3] +
              M[0,0] * M[1,3] * M[2,1] +
              M[1,0] * M[0,1] * M[2,3] -
              M[1,0] * M[0,3] * M[2,1] -
              M[2,0] * M[0,1] * M[1,3] +
              M[2,0] * M[0,3] * M[1,1];

  inv[3,3]:=  M[0,0] * M[1,1] * M[2,2] -
              M[0,0] * M[1,2] * M[2,1] -
              M[1,0] * M[0,1] * M[2,2] +
              M[1,0] * M[0,2] * M[2,1] +
              M[2,0] * M[0,1] * M[1,2] -
              M[2,0] * M[0,2] * M[1,1];

  det:= M[0,0] * inv[0,0] + M[0,1] * inv[1,0] + M[0,2] * inv[2,0] + M[0,3] * inv[3,0];

  if Abs(det)<1e-40 then
  begin
    Result:= Identity4f;
    exit;
  end;

  det:= 1.0 / det;

  for j:= 0 to 3 do
    for i:= 0 to 3 do
      Result[i,j]:= inv[i,j] * det;
end;

function  Transpose(const M: TMatrix4f): TMatrix4f;
begin
  Result[0,0] := M[0,0]; Result[0,1] := M[1,0]; Result[0,2] := M[2,0]; Result[0,3] := M[3,0];
  Result[1,0] := M[0,1]; Result[1,1] := M[1,1]; Result[1,2] := M[2,1]; Result[1,3] := M[3,1];
  Result[2,0] := M[0,2]; Result[2,1] := M[1,2]; Result[2,2] := M[2,2]; Result[2,3] := M[3,2];
  Result[3,0] := M[0,3]; Result[3,1] := M[1,3]; Result[3,2] := M[2,3]; Result[3,3] := M[3,3];
end;

procedure Translate(var M: TMatrix4f; const V: TVector3f);
begin
  M[3,0]:= M[3,0]+V.X;
  M[3,1]:= M[3,1]+V.Y;
  M[3,2]:= M[3,2]+V.Z;
end;

procedure Translate(var M: TMatrix4f; const X, Y, Z: Single);
begin
  M[3,0]:= M[3,0]+X;
  M[3,1]:= M[3,1]+Y;
  M[3,2]:= M[3,2]+Z;
end;

procedure Scale(var M: TMatrix4f; const s: Single);
begin
  M[0,0]:= M[0,0] * s;
  M[0,1]:= M[0,1] * s;
  M[0,2]:= M[0,2] * s;
  M[1,0]:= M[1,0] * s;
  M[1,1]:= M[1,1] * s;
  M[1,2]:= M[1,2] * s;
  M[2,0]:= M[2,0] * s;
  M[2,1]:= M[2,1] * s;
  M[2,2]:= M[2,2] * s;
end;

procedure Scale(var M: TMatrix4f; const x, y, z: Single);
var Mat: TMatrix4f;
begin
  Mat:= Identity4f;
  Mat[0,0]:= x; Mat[1,1]:= y; Mat[2,2]:= z;
 // M:= Mult(Mat, M);
  M:= Mult(M, Mat);
end;

procedure Scale(var M: TMatrix4f; const v: TVector3f);
var Mat: TMatrix4f;
begin
  Mat:= Identity4f;
  Mat[0,0]:= V.X; Mat[1,1]:= V.Y; Mat[2,2]:= V.Z;
  M:= Mult(M, Mat);
end;

procedure LookAt(out M: TMatrix4f; const eye, target, up: TVector3f);
var X, Y, Z: TVector3f;
begin
  Z:= Sub(eye, target);
  Normalize(Z);
  X:= Cross(up, Z);
  Normalize(X);
  Y:= Cross(Z, X);
  Normalize(Y);

  M[0,0]:= X.X;
  M[1,0]:= X.Y;
  M[2,0]:= X.Z;
  M[3,0]:= -Dot(eye, X);

  M[0,1]:= Y.X;
  M[1,1]:= Y.Y;
  M[2,1]:= Y.Z;
  M[3,1]:= -Dot(eye, Y);

  M[0,2]:= Z.X;
  M[1,2]:= Z.Y;
  M[2,2]:= Z.Z;
  M[3,2]:= -Dot(eye, Z);

  M[0,3]:= 0;
  M[1,3]:= 0;
  M[2,3]:= 0;
  M[3,3]:= 1;
end;

function  LookAt(const eye, target, up: TVector3f): TMatrix4f;
var X, Y, Z: TVector3f;
begin
  Z:= Sub(eye, target);
  Normalize(Z);
  X:= Cross(up, Z);
  Normalize(X);
  Y:= Cross(Z, X);
  Normalize(Y);

  Result[0,0]:= X.X;
  Result[1,0]:= X.Y;
  Result[2,0]:= X.Z;
  Result[3,0]:= -Dot(eye, X);

  Result[0,1]:= Y.X;
  Result[1,1]:= Y.Y;
  Result[2,1]:= Y.Z;
  Result[3,1]:= -Dot(eye, Y);

  Result[0,2]:= Z.X;
  Result[1,2]:= Z.Y;
  Result[2,2]:= Z.Z;
  Result[3,2]:= -Dot(eye, Z);

  Result[0,3]:= 0;
  Result[1,3]:= 0;
  Result[2,3]:= 0;
  Result[3,3]:= 1;
end;

procedure Rotate(var M: TMatrix4f; const A, X, Y, Z: Single);
var M1, M2, M3, M4: TMatrix4f;
    Deg,
    S, C: Single;
    Cases: Cardinal;
begin
  if (X=Y) AND (Y=X) AND (X=Z) AND (Z=0) then
    exit;
  Deg:= A;
  SinCos(Deg, S, C);

  if X<>0 then
  begin
    Cases:= 1;
    M1:= Identity4f;
    M1[1,1]:= C;
    M1[1,2]:= S;
    M1[2,1]:=-S;
    M1[2,2]:= C;
  end
  else Cases:= 0;

  if Y<>0 then
  begin
    Cases:= Cases OR 2;
    M2:= Identity4f;
    M2[0,0]:= C;
    M2[0,2]:=-S;
    M2[2,0]:= S;
    M2[2,2]:= C;
  end;

  if Z<>0 then
  begin
    Cases:= Cases OR 4;
    M3:= Identity4f;
    M3[0,0]:= C;
    M3[0,1]:= S;
    M3[1,0]:=-S;
    M3[1,1]:= C;
  end;
  M4:= M;
  case Cases of
    0: M:= M4;
    1: M:= M1;
    2: M:= M2;
    3: M:= Mult(M1, M2);
    4: M:= M3;
    5: M:= Mult(M1, M3);
    6: M:= Mult(M2, M3);
    7: begin
         M:= Mult(M1, M2);
         M:= Mult(M1, M3);
       end;
  end;
  M:= Mult(M4, M);
end;

procedure Rotate(var M: TMatrix4f; const p: TVector3f);
var
  cr, cp, cy, sr, sp, sy: Single;
begin
  SinCos(p.X, sr, cr);
  SinCos(p.X, sp, cp);
  SinCos(p.X, sy, cy);

  M[0,0]:= cp * cy;
  M[0,1]:= cp * sy;
  M[0,2]:= - sp;
  M[0,3]:= 0;
  M[1,0]:= sr * sp * cy - cr * sy;
  M[1,1]:= sr * sp * sy + cr * cy;
  M[1,2]:= sr * cp;
  M[1,3]:= 0;
  M[2,0]:= cr * sp * cy + sr * sy;
  M[2,1]:= cr * sp * sy - sr * cy;
  M[2,2]:= cr * cp;
  M[2,3]:= 0;
  M[3,0]:= 0;
  M[3,1]:= 0;
  M[3,2]:= 0;
  M[3,3]:= 1;
end;

procedure GetRotate(out M2: TMatrix4f; const M: TMatrix4f);
begin
  M2[0,0]:= M[0,0]; M2[1,0]:= M[1,0]; M2[2,0]:= M[2,0]; M2[3,0]:= 0;
  M2[0,1]:= M[0,1]; M2[1,1]:= M[1,1]; M2[2,1]:= M[2,1]; M2[3,1]:= 0;
  M2[0,2]:= M[0,2]; M2[1,2]:= M[1,2]; M2[2,2]:= M[2,2]; M2[3,2]:= 0;
  M2[0,3]:= 0;      M2[1,3]:= 0;      M2[2,3]:= 0;      M2[3,3]:= 1;
end;

procedure GetRotate(out M2: TMatrix3f; const M: TMatrix4f);
begin
  M2[0,0]:= M[0,0]; M2[1,0]:= M[1,0]; M2[2,0]:= M[2,0];
  M2[0,1]:= M[0,1]; M2[1,1]:= M[1,1]; M2[2,1]:= M[2,1];
  M2[0,2]:= M[0,2]; M2[1,2]:= M[1,2]; M2[2,2]:= M[2,2];
end;

function  GetRotate(const M: TMatrix4f): TMatrix3f; overload;
begin
  Result[0,0]:= M[0,0]; Result[1,0]:= M[1,0]; Result[2,0]:= M[2,0];
  Result[0,1]:= M[0,1]; Result[1,1]:= M[1,1]; Result[2,1]:= M[2,1];
  Result[0,2]:= M[0,2]; Result[1,2]:= M[1,2]; Result[2,2]:= M[2,2];
end;

function  GetTranslate(const M: TMatrix4f): TVector3f;
begin
  Result.X:= M[3,0];
  Result.Y:= M[3,1];
  Result.Z:= M[3,2];
end;

procedure Ortho(out M: TMatrix4f; const vleft, vright, vbottom, vtop, vnear, vfar: Single);
var
  RL, TB, FN: Single;
begin
  if (vleft = vright) OR (vbottom = vtop) OR (vnear = vfar) then
    exit;
  RL:= vright-vleft;
  TB:= vtop-vbottom;
  FN:= vfar-vnear;

  M[0,0]:= 2 / RL;
  M[0,1]:= 0;
  M[0,2]:= 0;
  M[0,3]:= 0;

  M[1,0]:= 0;
  M[1,1]:= 2 / TB;
  M[1,2]:= 0;
  M[1,3]:= 0;

  M[2,0]:= 0;
  M[2,1]:= 0;
  M[2,2]:= -2 / FN;
  M[2,3]:= 0;

  M[3,0]:= -(vright+ vleft) / RL;
  M[3,1]:= -(vtop  + vbottom) / TB;
  M[3,2]:= -(vfar  + vnear) / FN;
  M[3,3]:= 1;
end;

procedure Frustum(out M: TMatrix4f; const vleft, vright, vbottom, vtop, vnear, vfar: Single);
var
  RL, TB, FN: Single;
begin
  if (vleft = vright) OR (vbottom = vtop) OR (vnear = vfar) then
    exit;
  RL:= vright-vleft;
  TB:= vtop-vbottom;
  FN:= vfar-vnear;
  M[0,0]:=  (2*vnear) / RL;
  M[0,1]:= 0;
  M[0,2]:= 0;
  M[0,3]:= 0;

  M[1,0]:= 0;
  M[1,1]:= (2*vnear) / TB;
  M[1,2]:= 0;
  M[1,3]:= 0;

  M[2,0]:= (vright+ vleft) / RL;
  M[2,1]:= (vtop  + vbottom) / TB;
  M[2,2]:= -(vfar + vnear) / FN;
  M[2,3]:= -1;

  M[3,0]:= 0;
  M[3,1]:= 0;
  M[3,2]:= 0;
  M[3,2]:= -(2*vfar*vnear) / FN;
end;

procedure Perspective(out M: TMatrix4f; const FOVY, aspect, vnear, vfar: Single);
var
  x, y: Single;
begin
  y:= vnear * Tan((DEG2RAD*Min(179.9, Max(0, FOVY))) * 0.5);
  x:= y*aspect;
  Frustum(M, -x, x, -y, y, vnear, vfar);
end;

operator =  (V1, V2: TVector3f): Boolean;
begin
  if (V1.X = V2.X) AND (V1.Y = V2.Y) AND (V1.Z = V2.Z) then
    Result:= TRUE
  else
    Result:= FALSE;
end;

operator + (V1, V2: TVector3f): TVector3f;
begin
  Result:= Add(V1, V2);
end;

operator -  (V: TVector3f): TVector3f;
begin
  Result.X:= -V.X;
  Result.Y:= -V.Y;
  Result.Z:= -V.Z;
end;

operator - (V1, V2: TVector3f): TVector3f;
begin
  Result:= Sub(V1, V2);
end;

operator *  (V: TVector3f; S: Single): TVector3f;
begin
  Result:= Scale(V, S);
end;

operator *  (S: Single; V: TVector3f): TVector3f;
begin
  Result:= Scale(V, S);
end;

operator := (V: TVector3f): Single;
begin
  Result:= Magnitude(V);
end;

// vector4f

operator +  (V1, V2: TVector4f): TVector4f;
begin
  Result:= Add(V1, V2);
end;

operator -  (V1, V2: TVector4f): TVector4f;
begin
  Result:= Sub(V1, V2);
end;

operator *  (V1, V2: TVector4f): Single;
begin
  Result:= Dot(V1, V2);
end;

operator *  (V: TVector4f; S: Single): TVector4f;
begin
  Result:= Scale(V, S);
end;

operator *  (S: Single; V: TVector4f): TVector4f;
begin
  Result:= Scale(V, S);
end;

// matrix 3f

operator * (M1, M2: TMatrix3f): TMatrix3f;
begin
  Result:= Mult(M1, M2);
end;

// matrix 4f

operator := (M: TMatrix4f): TMatrix3f;
begin
  PVector3f(@Result[0,0])^:= PVector3f(@M[0,0])^;
  PVector3f(@Result[1,0])^:= PVector3f(@M[1,0])^;
  PVector3f(@Result[2,0])^:= PVector3f(@M[2,0])^;
end;

operator * (M1, M2: TMatrix4f): TMatrix4f;
begin
  Result:= Mult(M2, M1);
end;

operator * (M: TMatrix4f; S: Single): TMatrix4f;
begin
  Result:= M;
  Scale(Result, S);
end;

operator * (M: TMatrix4f; V: TVector3f): TVector3f;
begin
  Result:= Mult(M, V);
end;

operator * (V: TVector3f; M: TMatrix4f): TVector3f;
begin
  Result:= Mult(M, V);
end;

operator + (M: TMatrix4f; V: TVector3f): TMatrix4f;
begin
  Result:= M;
  Translate(Result, V);
end;

end.
