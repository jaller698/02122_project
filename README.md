# Introduction
This project repository, is divided into parts. A Backend which is the server and a Frontend, which is the mobile application.

Each class or function, has a author (or co-authors) which are the people who contributed to the development of that specific part of the project.

# How to run? 
## Mobile application
To run the mobile application, you need to have the following tools installed:
- flutter

After installing the tools, you need to run the following commands (assuming you already have a emulator running or a device connected to the computer):

```bash
cd Frontend
flutter pub get
flutter run
```

It should then connect to the remote server, and you should be able to use the application.

## Server
To run the server, you need to have the following tools installed:
- docker

After installing the tools, you need to run the following commands:

unix-like: 
```bash
cd Backend
./start_server.sh
```

windows:
```bat
cd Backend
start_server.bat
```
Of course nothing will happen, unless you connect the mobile application to the server. (Line 17 in settings_controller.dart)

To run the unit tests of the server just add the `test` argument to the script:
unix-like: 
```bash
cd Backend
./start_server.sh test
```

windows:
```bat
cd Backend
start_server.bat test
```

