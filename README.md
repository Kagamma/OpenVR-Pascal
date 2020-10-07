### Unofficial Free Pascal bindings for Valve's OpenVR SDK ###

### The demo can be built with the following command on win32 environment:

* fpc -Mobjfpc -Fusrc -FEbin -gl -gw2 demo/demo.pas

You need to obtain glfw3.dll and openvr_api.dll from official website and put them in ./bin so that the demo can run.

Note that math3d.pas borrows some of it's code from GLScene so the source code is released under Mozilla Public Licence 1.1

![Screenshot](https://i.imgur.com/jcrbIkv.png)