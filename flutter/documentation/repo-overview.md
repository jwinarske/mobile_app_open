
This file describes structure of this repo.

The app is built using Flutter framework.  
Most Flutter-related files are located in the [lib](../lib) folder.

[comment]: # (Don't remove spaces at the end of lines, they force line breaks)
An important part of the app is the backend.
Currently we only have the default backend.  
Backend-related files are located in the [cpp](../cpp) folder.  
Most of the files there can actually be considered a "middle-end",
to interact between Flutter/Dart code and the real backend.

The real backend is contained in the [cpp/backend_tflite](../cpp/backend_tflite) folder.
You can find declarations of interfaces that this backend implements in the [cpp/c](../cpp/c) folder.

All supported platforms have their dedicated folders: [windows](../windows), [ios](../ios).  
These folders contain platform-related settings and code.
These folders _mostly_ contain files that are generated by Flutter without much changes.