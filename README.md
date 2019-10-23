# [Hack Heroes](hackheroes.pl)
Connected projects:
- [Server](https://github.com/Carbon225/hack-heroes-2019-server)
- [Keyboard](https://github.com/Carbon225/hack-heroes-2019-keyboard)
## Overview
This is my mobile app for the Hack Heroes 2019 competition.
Its purpose is to help deafblind people perceive the environment by sending images and text written with a Braille keyboard to other users of the app that can answer their questions.
For example, someone could send a photo of some medicine or food and ask for the expiration date.
After sending the photo other users who downloaded the app and selected volunteer mode would receive a notification with the image and text.
If they respond the text message is sent back to the deafblind person and played back on their keyboard.
## Installation
### Use the precompiled binary
Download and install the latest *.apk* file from the *Releases* page.  
You do not need to run your own server because the compiled application is configured to use my server.
### Compile from source
1. Install and run the [hack-heroes-2019-server](https://github.com/Carbon225/hack-heroes-2019-server)
2. Open the Firebase console and follow the instructions for adding a new app
3. Configure the server IP and port in the <code>/lib/client/server_options.dart</code> file
4. [Compile for release](https://flutter.dev/docs/deployment/android)
## Usage
### Configuration
1. If needed grant camera permissions
2. Choose a mode
3. Enable demo mode to simulate a 6-key Braille keyboard
### Blind Mode
1. To input characters press the keys corresponding to the dots in the Braille alphabet. Key C is space and Key D is backspace.
2. To call for help point the camera at an object and press the lifebuoy on the screen (in the final version the user would press a button on the keyboard)
### Helper mode
1. Wait for a notification
2. A card will appear with an image and some text
3. Type in the answer and press send
