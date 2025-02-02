//
//  Untitled.swift
//  SCam.
//
//  Created by Murillo Alves da Silva on 02/02/25.
//
import Foundation
import AVFoundation

class CameraManager : NSObject{
    private let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var isAuthorized : Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
      
      lazy var previewStream: AsyncStream<CGImage> = {
          AsyncStream { continuation in
              addToPreviewStream = { cgImage in
                  continuation.yield(cgImage)
              }
          }
      }()
    
    private func configureSession() async {
        // 1.
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
    }
    
    private func startSession() async {
          guard await isAuthorized else { return }
          captureSession.startRunning()
      }
    override init() {
         super.init()
         
         Task {
             await configureSession()
             await startSession()
         }
     }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addToPreviewStream?(currentFrame)
    }
    
}
