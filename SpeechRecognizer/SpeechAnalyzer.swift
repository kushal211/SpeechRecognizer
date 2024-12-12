//
//  SpeechAnalyzer.swift
//  SpeechRecognizer
//
//  Created by Kushal Panchal on 12/12/24.
//
// https://www.portray.work/kushal

import Speech
import SwiftUI

/// A class responsible for managing speech recognition tasks, including starting, pausing, resuming, and stopping.
/// It uses Apple's Speech framework and AVAudioEngine for real-time audio processing.
final class SpeechAnalyzer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {

    // MARK: - Properties

    /// The audio engine used for recording and processing audio input.
    private let audioEngine = AVAudioEngine()

    /// The input node from the audio engine for capturing audio.
    private var inputNode: AVAudioInputNode?

    /// The speech recognizer for converting speech to text.
    private var speechRecognizer: SFSpeechRecognizer?

    /// The recognition request for handling live audio input.
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    /// The recognition task responsible for managing the transcription process.
    private var recognitionTask: SFSpeechRecognitionTask?

    /// A timer to monitor silence duration during speech recognition.
    private var silenceTimer: Timer?

    /// The recognized text from the speech recognition process.
    @Published var recognizedText: String?

    /// A flag indicating whether speech recognition is currently active.
    @Published var isProcessing: Bool = false

    /// A flag indicating whether the speech recognition is paused.
    @Published var isPaused: Bool = false

    /// The duration (in seconds) of silence after which speech recognition will automatically stop.
    /// If `silenceDuration` is set to 0 or less, the auto-stop feature is disabled.
    var silenceDuration: TimeInterval = 5.0

    // MARK: - Methods

    /// Starts the speech recognition process.
    /// Configures the audio session, initializes speech recognition components, and starts audio processing.
    func start() {
        guard !isProcessing else { return }

        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session configuration failed: \(error)")
            return
        }

        // Setup audio input
        inputNode = audioEngine.inputNode
        speechRecognizer = SFSpeechRecognizer()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let speechRecognizer = speechRecognizer,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode else {
            print("Failed to initialize speech recognition components.")
            return
        }

        // Assign delegate and configure recognition task
        speechRecognizer.delegate = self
        recognitionRequest.shouldReportPartialResults = true

        // Install audio tap to capture audio buffers
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            recognitionRequest.append(buffer)
        }

        // Start recognition task
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                self.resetSilenceTimer()
            }
            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                self.stop()
            }
            if result?.isFinal == true {
                self.stop()
            }
        }

        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isProcessing = true
            isPaused = false
            startSilenceTimer()
        } catch {
            print("Failed to start audio engine: \(error)")
            stop()
        }
    }

    /// Pauses the ongoing speech recognition process.
    /// Temporarily halts audio engine processing without stopping the recognition task.
    func pause() {
        guard isProcessing, !isPaused else { return }
        audioEngine.pause()
        silenceTimer?.invalidate()
        isPaused = true
        print("Speech recognition paused.")
    }

    /// Resumes the paused speech recognition process.
    /// Restarts audio engine processing and resets the silence timer.
    func resume() {
        guard isPaused else { return }
        do {
            try audioEngine.start()
            isPaused = false
            startSilenceTimer()
            print("Speech recognition resumed.")
        } catch {
            print("Failed to resume audio engine: \(error)")
            stop()
        }
    }

    /// Stops the speech recognition process.
    /// Cancels the recognition task, stops audio processing, and logs the final recognized text.
    func stop() {
        guard isProcessing else { return }

        // Finish recognition request to ensure final results are processed
        recognitionRequest?.endAudio()
        
        // Wait for the recognition task to process the final buffer
        recognitionTask?.finish()

        // Stop the audio engine
        audioEngine.stop()
        inputNode?.removeTap(onBus: 0)

        // Ensure the silence timer is invalidated (if any)
        silenceTimer?.invalidate()
        silenceTimer = nil

        // Log the final recognized text
        if let finalText = recognizedText, !finalText.isEmpty {
            print("Final recognized text: \(finalText)")
        } else {
            print("No speech recognized.")
        }

        // Reset state
        isProcessing = false
        isPaused = false
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
        inputNode = nil
    }

    /// SFSpeechRecognizerDelegate method to handle availability changes.
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("Speech recognition is now available.")
        } else {
            print("Speech recognition is unavailable.")
            stop()
        }
    }

    // MARK: - Private Methods

    /// Starts the silence timer to monitor inactivity during speech recognition.
    /// If `silenceDuration` is set to 0 or less, the auto-stop feature is disabled.
    private func startSilenceTimer() {
        silenceTimer?.invalidate()
        
        // Disable auto-stop if silenceDuration is 0 or less
        guard silenceDuration > 0 else {
            print("Auto-stop feature is disabled because silenceDuration is \(silenceDuration).")
            return
        }

        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            print("Silence detected for \(self.silenceDuration) seconds. Stopping recognition.")
            self.stop()
        }
    }

    /// Resets the silence timer when speech is detected.
    private func resetSilenceTimer() {
        startSilenceTimer()
    }
}
