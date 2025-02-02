//
//  CameraViewModel.swift
//  SCam.
//
//  Created by Murillo Alves da Silva on 02/02/25.
//

import Foundation
import CoreImage

@Observable
class CameraViewModel {
    var currentFrame: CGImage?
    private let cameraManager = CameraManager()
    var quantity:Int? = 1
    var timer:Double? = 0.0
    init() {
          Task {
              await handleCameraPreviews()
          }
      }
    
    func setQuantityImageCapture(quantity: Int?) {
        self.quantity = quantity
    }
    
    func timerStart(timer: Double?) {
        self.timer = timer
        print(self.timer ?? 0.0)
    }
      
    func handleCameraPreviews() async {
           for await image in cameraManager.previewStream {
               Task { @MainActor in
                   currentFrame = image
               }
           }
       }
}
