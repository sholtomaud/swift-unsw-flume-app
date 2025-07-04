import SwiftUI
import AVFoundation

struct VideoRecorderView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onVideoRecorded: ((URL) -> Void)?

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        context.coordinator.setupCamera(in: viewController.view)

        // Add a button for recording
        let recordButton = UIButton(type: .system)
        recordButton.setTitle("Start Recording", for: .normal)
        recordButton.backgroundColor = .green
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 10
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.addTarget(context.coordinator, action: #selector(Coordinator.toggleRecording), for: .touchUpInside)
        context.coordinator.recordButton = recordButton // Store reference to update title/color
        viewController.view.addSubview(recordButton)

        // Add a button for dismissing
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.backgroundColor = .gray
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.cornerRadius = 10
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(context.coordinator, action: #selector(Coordinator.dismiss), for: .touchUpInside)
        viewController.view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            recordButton.widthAnchor.constraint(equalToConstant: 150),
            recordButton.heightAnchor.constraint(equalToConstant: 50),

            dismissButton.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            dismissButton.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
            dismissButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(dismissAction: { presentationMode.wrappedValue.dismiss() }, onVideoRecorded: onVideoRecorded)
    }

    class Coordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
        var captureSession: AVCaptureSession?
        var movieOutput: AVCaptureMovieFileOutput?
        var previewLayer: AVCaptureVideoPreviewLayer!
        weak var recordButton: UIButton? // Use weak to avoid retain cycle
        private let sessionQueue = DispatchQueue(label: "session queue")

        var dismissAction: (() -> Void)?
        var onVideoRecordedAction: ((URL) -> Void)?

        init(dismissAction: (() -> Void)?, onVideoRecorded: ((URL) -> Void)?) {
            self.dismissAction = dismissAction
            self.onVideoRecordedAction = onVideoRecorded
        }

        func setupCamera(in view: UIView) {
            print("Attempting to set up camera.")
            // Check if running in UI Test mode
            if ProcessInfo.processInfo.environment["XCUITEST_MODE"] == "1" {
                print("Running in UI Test mode, skipping camera setup.")
                return
            }

            // Request camera and microphone access
            AVCaptureDevice.requestAccess(for: .video) { [weak self] grantedVideo in
                AVCaptureDevice.requestAccess(for: .audio) { [weak self] grantedAudio in
                    guard let self = self else { return }
                    if grantedVideo && grantedAudio {
                        self.sessionQueue.async { [weak self] in
                            guard let self = self else { return }
                            self.configureCamera(in: view)
                        }
                    } else {
                        print("Camera or microphone access denied.")
                    }
                }
            }
        }

        private func configureCamera(in view: UIView) {
            print("Camera and microphone access granted.")
            self.captureSession = AVCaptureSession()
            self.captureSession?.sessionPreset = .high

            // Configure video input
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Failed to get video device.")
                return
            }
            guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                print("Failed to create video input.")
                return
            }
            if self.captureSession?.canAddInput(videoInput) == true {
                self.captureSession?.addInput(videoInput)
                print("Video input added.")
            } else {
                print("Failed to add video input to capture session.")
                return
            }

            // Configure audio input
            guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
                print("Failed to get audio device.")
                return
            }
            guard let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else {
                print("Failed to create audio input.")
                return
            }
            if self.captureSession?.canAddInput(audioInput) == true {
                self.captureSession?.addInput(audioInput)
                print("Audio input added.")
            } else {
                print("Failed to add audio input to capture session.")
                return
            }

            // Configure movie output
            self.movieOutput = AVCaptureMovieFileOutput()
            if let movieOutput = self.movieOutput, self.captureSession?.canAddOutput(movieOutput) == true {
                self.captureSession?.addOutput(movieOutput)
                print("Movie output added.")
                // Ensure the movie output has a connection to the video input
                if let connection = movieOutput.connection(with: .video) {
                    if connection.isCameraIntrinsicMatrixDeliverySupported {
                        connection.isCameraIntrinsicMatrixDeliveryEnabled = true
                    }
                }
            } else {
                print("Failed to add movie output to capture session.")
                return
            }

            // Start capture session
            self.captureSession?.startRunning()
            print("Capture session started running.")

            // Configure preview layer on the main thread after session starts
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let captureSession = self.captureSession {
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    self.previewLayer.frame = view.bounds
                    self.previewLayer.videoGravity = .resizeAspectFill
                    view.layer.insertSublayer(self.previewLayer, at: 0) // Insert at 0 to be behind buttons
                    print("Preview layer configured.")
                }
            }
        }

        @objc func toggleRecording(_ sender: UIButton) {
            sessionQueue.async { [weak self] in
                guard let self = self else { return }
                guard let movieOutput = self.movieOutput else { return }

                if movieOutput.isRecording {
                    self.stopRecording()
                    DispatchQueue.main.async {
                        sender.setTitle("Start Recording", for: .normal)
                        sender.backgroundColor = .green
                    }
                } else {
                    self.startRecording()
                    DispatchQueue.main.async {
                        sender.setTitle("Stop Recording", for: .normal)
                        sender.backgroundColor = .red
                    }
                }
            }
        }

        @objc func dismiss() {
            dismissAction?()
        }

        func startRecording() {
            guard let movieOutput = movieOutput,
                  let captureSession = captureSession,
                  captureSession.isRunning,
                  !movieOutput.isRecording else {
                print("Cannot start recording.")
                return
            }

            guard let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Could not find document directory.")
                return
            }
            let fileUrl = paths.appendingPathComponent("output.mov")
            // Remove the file if it already exists
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    try FileManager.default.removeItem(at: fileUrl)
                } catch {
                    print("Could not remove existing file: \(error)")
                    return
                }
            }
            movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }

        func stopRecording() {
            guard let movieOutput = movieOutput, movieOutput.isRecording else {
                print("Movie output is not recording.")
                return
            }
            movieOutput.stopRecording()
        }

        deinit {
            // Synchronously stop the capture session on its queue to ensure it's torn down before deallocation completes
            sessionQueue.sync {
                if let captureSession = self.captureSession, captureSession.isRunning {
                    captureSession.stopRunning()
                    print("Capture session stopped.")
                }
            }
        }

        // MARK: - AVCaptureFileOutputRecordingDelegate
        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let error = error {
                    print("Error recording movie: \(error.localizedDescription)")
                } else {
                    print("Video recorded to: \(outputFileURL.absoluteString)")
                    self.onVideoRecordedAction?(outputFileURL)
                }
            }
        }
    }
}