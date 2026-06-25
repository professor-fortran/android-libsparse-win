## Description

This is a project for porting utilities from the `libsparse` package of the repository https://android.googlesource.com/platform/system/core/ to the Windows:
1. simg2img.exe
1. img2simg.exe
1. append2simg.exe
1. simg_dump.exe

The porting process also utilizes certain header and source code files from the repository https://android.googlesource.com/platform/system/libbase/.

The source codes used are the most recent as of 2026-06-25.

I would like to express my gratitude to the following similar projects, which served as the foundation for this project:
1. https://github.com/anestisb/android-simg2img (this project was used as a reference)
1. https://github.com/KinglyWayne/simg2img_win
1. https://github.com/thka2016/lpunpack_and_lpmake_cmake/releases

Project https://github.com/anestisb/android-simg2img is good, but some obsolete and I can't build it despite there is a conrete build command in this repo specially for windows.

## Build

If you want to build it by yourself, you'll need to use MSYS2 MSYS console.

In MSYS2 MSYS you need to install:
```sh
pacman -S --needed make gcc zlib-devel zip mingw-w64-x86_64-python mingw-w64-x86_64-python-pip

/mingw64/bin/pip install pyinstaller --break-system-packages
```

Then you can build all by regular `make` command.
Command `make dist` can pack all the exe-s to a zip into `dist` folder.
Command `make clean` can clean sources folder.
