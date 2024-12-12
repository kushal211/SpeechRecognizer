//
//  SpeechRecognitionView.swift
//  SpeechRecognizer
//
//  Created by Kushal Panchal on 12/12/24.
//
// https://www.portray.work/kushal

import SwiftUI

/// A SwiftUI view that provides a user interface for controlling the speech recognition process.
struct SpeechRecognitionView: View {
    private enum Constants {
        static let buttonSize: CGFloat = 100
    }

    @ObservedObject private var speechAnalyzer = SpeechAnalyzer()

    var body: some View {
        VStack {
            Spacer()
            Text(speechAnalyzer.recognizedText ?? "Tap to begin")
                .padding()

            HStack {
                Button(action: toggleSpeechRecognition) {
                    Image(systemName: speechAnalyzer.isProcessing ? "stop.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                        .foregroundColor(speechAnalyzer.isProcessing ? .red : .green)
                }

                if speechAnalyzer.isProcessing {
                    Button(action: togglePauseResume) {
                        Image(systemName: speechAnalyzer.isPaused ? "play.circle.fill" : "pause.circle.fill")
                            .resizable()
                            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                            .foregroundColor(speechAnalyzer.isPaused ? .green : .orange)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Private Methods

private extension SpeechRecognitionView {
    /// Toggles between starting and stopping the speech recognition process.
    func toggleSpeechRecognition() {
        if speechAnalyzer.isProcessing {
            speechAnalyzer.stop()
        } else {
            speechAnalyzer.start()
        }
    }

    /// Toggles between pausing and resuming the speech recognition process.
    func togglePauseResume() {
        if speechAnalyzer.isPaused {
            speechAnalyzer.resume()
        } else {
            speechAnalyzer.pause()
        }
    }
}

struct SpeechRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechRecognitionView()
    }
}
