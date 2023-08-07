# Appscrip Chat Component

[![Appscrip](./assets/logo/appscrip.png)](https://appscrip.com/)
[![isometrik.io](./assets/logo/isometric.png)](https://isometrik.io/)

`Appscrip Chat Component` is a package to support chat functionality in flutter projects using Isometric

## Setup

* [Android](./README_android.md)
* [iOS](./README_ios.md)
* [Web](./README_web.md)

## Initialization

WidgetsFlutterBinding.ensureInitialized();
AppscripChatComponent.initialize();
LocalNoticeService().setup();

## Code UseCase

1. Get all conversation form db if you want
2. Update conversation with meta data
3. Get chat conversation with latest db
4. Logout
5. Delete chat
6. InitializeMqtt if you want from outside,
7. Add listener for Mqtt evetns
8. Chat from outside with out coversation
9. Chat form outside wiht conversation
