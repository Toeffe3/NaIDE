# NaIDE - _The project manager_
> NaIDE - it is NOT an IDE!

It is a project manager with features to create, compile and run  
various different languages, all collected in one place.

_NaIDE v0.1.1_

##### Features:
* Open source & free.
* Fast & lightweight.
* Portable.
* User customizable.
* Easy to use, graphical/guided interface.
* Graphical: No _commandpromt_/_shell_ experience needed.
* ~~Multiple editor to choose between.~~
* ~~Change settings from within program.~~
* ~~interface.sh for Linux & Mac OS.~~
* ~~Project/environment/executable export.~~

---
##### Starting NaIDE:
To open NaIDE simply _double-click_ the `interface.bat`. Furthermore  
NaIDE can be opened via. the _commandpromt_ with following arguments:

    interface.cmd [-T title] [-C color] [-O project]
    interface.cmd [-S]
    interface.cmd [-I]

* ``-T title`` - _Set the window title._
* ``-C color`` - _Set the color._
* ``-O project`` - _Open project with default editor, where project is a path._
* ``-S`` - _Open the settings file._
* ``-I`` - _Set environment variable, so `naide` can be used to instead of path/to/interface.bat_

---
##### settings.properties:
`settings.properties` is the NaIDE main settings file, it contains  
all settings and global variables required for NaIDE to run properly.  
You can manually specify paths/properties for your needs.

All settings is separated into categories, to apply a setting type the  
category name followed by a `.` and the property followed by a `=`  
and the desired value.

__Category: `naide`__
* `proj`: _Specify the project folder (relative). eg. `..\projects`._
* `lang`: _Specify the languages folder (relative). eg. `..\languages`._
* `rsrc`: _Specify the resources folder (relative). eg. `..\resources`._
* `chcp`: _Change the CMD character set, to show local characters correctly. eg. `65001`._
* `temp`: _Specify the temporary folder (relative), content is deleted upon exit. eg. `..\_temp`._
* ~~`showalllang`: _Show languages that can be received from web and local OR local only. eg. `false`._~~
* ~~`openexplorer`: _When to open project folder in explorer, options: `never`, `default`, `always`._~~

__Category: `user`__
* `key1`: _Specify key 1. (navigation, option) eg. `W`._
* `key2`: _Specify key 2. (navigation, option) eg. `A`._
* `key3`: _Specify key 3. (navigation, option) eg. `D`._
* `key4`: _Specify key 4. (navigation, option) eg. `S`._
* `key5`: _Specify key 5. (special, escape) eg. `X`._
* `keycancel`: _Specify the cancel key (cancel, exit, back) eg. `E`_
* `keycontrol`: _Specify the cancel key (OK, toggle, back) eg. `Q`_
* `editor1`: _Specify the text editor to use for opening files. eg. `%appdata%\Local\tom\atom.exe`_
* `editor1supportsfolder`: _If true NaIDE will open the project folder in the editor if false just the main file._

__Category: `mics`__
* `latest`: _[Handled by NaIDE] Stores latest project path. eg. `C:\NaIDE\projects\HelloWorld`._
* `title`: _Set the window title to something catchy. eg. `Who you gonna call, CodeBuster!`._
* `background`: _Set the background color [0-F]. eg. `0`._
* `foreground`: _Set the foreground color [0-F]. eg. `A`._
* `errorcolor`: _Set the error foreground color [0-F]. eg. `E`._
* `titlescreentext`: _Set the text to be displayed on main screen (exactly 35 chars). eg. `‌ ‌ ‌ ‌ ‌ ‌ PLEASE SELECT AN OPTION ‌ ‌ ‌ ‌ ‌ `._

---
##### Addons
Addons is extension scripts that will allow you to add extra  
functionality to NaIDE. Here is a list of NaIDE-official addons:

* ~~GIT-Integration~~
* ~~Automatic language setup/download/managing~~
