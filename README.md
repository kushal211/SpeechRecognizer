![Markdown-SpeechRecognizer-banner-image](assets/banner.png)

# SpeechRecognizer
A SwiftUI-based iOS application that uses Apple’s Speech framework to perform real-time speech-to-text transcription. This app supports starting, pausing, resuming, and stopping speech recognition, with an optional auto-stop feature based on a configurable silence duration.

---
### Features
* Real-time speech-to-text transcription.
* Start, Pause, Resume, and Stop speech recognition.
* Optional auto-stop functionality triggered after a specified duration of silence.
* Configurable silence duration for flexible behavior.
* Logs the final recognized text to the console when recognition stops.
* Dynamic UI reflecting the current recognition state.

---
### Requirements
* iOS 14.0+
* Xcode 15.0+
* Swift 5.0+
* Device with microphone access and speech recognition permissions enabled.

---
### Installation
1. Clone the repository:
```
git clone <repository-url>
```

2. Open the project in Xcode:
```
cd <project-folder>
open SpeechRecognizer.xcodeproj
```

1. Build and run the project on a real iOS device or simulator (microphone access required).

---
### Usage

1. Launch the app.
2. Start Speech Recognition:
    * Tap the green “**Play**” button to begin speech recognition.
    *  Speak into the microphone to see real-time transcription.
3. Pause Speech Recognition:
    * Tap the orange “**Pause**” button to temporarily halt recognition.
4. Resume Speech Recognition:
    * Tap the green “**Play**” button again to continue recognition.
5. Stop Speech Recognition:
    * Tap the red “**Stop**” button to stop recognition and log the final transcribed text.

##### Auto-Stop Feature
* By default, the app will automatically stop recognition after 5 seconds of silence.
* To customize or disable this feature:
    * Set `silenceDuration` in SpeechAnalyzer:

```
speechAnalyzer.silenceDuration = 10 // Set to 10 seconds
speechAnalyzer.silenceDuration = 0  // Disable auto-stop
```

---
### Code Overview

**SpeechAnalyzer**
* **Purpose**: 
    * Core logic for managing speech recognition using SFSpeechRecognizer and AVAudioEngine.
* **Key Methods**:
    * `start()`: Starts speech recognition.
    * `pause()`: Pauses the recognition process.
    * `resume()`: Resumes the paused recognition.
    * `stop()`: Stops recognition and logs the final result.
* **Auto-Stop Behavior**:
    * Monitors silence using a configurable silenceDuration.
    * Stops recognition automatically if no speech is detected within the specified duration.

* **SpeechRecognitionView**
    * Purpose: Provides a user interface to interact with the SpeechAnalyzer.
    * Key Features:
        * Buttons for starting, pausing, resuming, and stopping speech recognition.
        * Dynamic button states based on recognition status.
        * Displays the recognized text in real time.
     
---
### Permissions
The app requires the following permissions:
* *Microphone Access*: To record audio for speech recognition.
* *Speech Recognition* Access: To perform transcription.

Ensure permissions are granted in your app’s `Info.plist`:
```
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for speech recognition.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>We need access to speech recognition for transcribing your speech.</string>
```
     
---
### Customization
1.	UI Customization:
* Modify SpeechRecognitionView to change button styles, text appearance, or layout.
2.	Silence Duration:
* Update silenceDuration in SpeechAnalyzer for custom auto-stop behavior.

---
### Troubleshooting
*	Speech Recognition Fails to Start:
    *	Ensure permissions are granted for microphone and speech recognition.
    *	Test on a real device if simulator doesn’t support speech recognition.
*	Auto-Stop Not Working:
    *	Verify that silenceDuration is greater than 0.

---
### License
This project is licensed under the MIT License. See the LICENSE file for details.

---
### Acknowledgments

This app leverages the following Apple frameworks:
*	`Speech Framework`: For speech-to-text transcription.
*	`AVFoundation`: For audio input and processing.

---
### Contact
[Kushal Panchal][portray-url] 

[![LinkedIn][linkedin-shield]][linkedin-url]


<!-- MARKDOWN LINKS & IMAGES -->
[linkedin-shield]: https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white
[portray-url]: https://www.portray.work/kushal
[linkedin-url]: https://www.linkedin.com/in/kushal211