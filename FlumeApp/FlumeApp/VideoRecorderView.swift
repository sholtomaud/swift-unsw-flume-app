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
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureFileOutputRecordingDelegate {
        var parent: VideoRecorderView
        var captureSession: AVCaptureSession!
        var movieOutput: AVCaptureMovieFileOutput!
        var previewLayer: AVCaptureVideoPreviewLayer!
        var isRecording = false
        weak var recordButton: UIButton? // Use weak to avoid retain cycle

        init(_ parent: VideoRecorderView) {
            self.parent = parent
        }

        func setupCamera(in view: UIView) {
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .high

            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }

            guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
            guard let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else { return }
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }

            movieOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.insertSublayer(previewLayer, at: 0) // Insert at 0 to be behind buttons

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }

        @objc func toggleRecording(_ sender: UIButton) {
            if isRecording {
                stopRecording()
                sender.setTitle("Start Recording", for: .normal)
                sender.backgroundColor = .green
            } else {
                startRecording()
                sender.setTitle("Stop Recording", for: .normal)
                sender.backgroundColor = .red
            }
            isRecording.toggle()
        }

        @objc func dismiss() {
            parent.presentationMode.wrappedValue.dismiss()
        }

        func startRecording() {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mov")
            movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        }

        func stopRecording() {
            movieOutput.stopRecording()
        }

        // MARK: - AVCaptureFileOutputRecordingDelegate
        func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
            if let error = error {
                print("Error recording movie: \(error.localizedDescription)")
            } else {
                print("Video recorded to: \(outputFileURL.absoluteString)")
                parent.onVideoRecorded?(outputFileURL)
            }
        }
    }
}