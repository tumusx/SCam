//
//  ImagePreview.swift
//  SCam.
//
//  Created by Murillo Alves da Silva on 02/02/25.
//

import SwiftUI

struct CameraView: View {
    
    private let cameraViewModel: CameraViewModel
    init(cameraViewModel: CameraViewModel) {
        self.cameraViewModel = cameraViewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
        
            if let image = cameraViewModel.currentFrame {
                    Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            } else {
                FieldCountImageView { value in
                    let value = Int(value)
                    cameraViewModel.setQuantityImageCapture(quantity: value)
                } onTimerChange: { value in
                    cameraViewModel.timerStart(timer: value)
                }
                ContentUnavailableView("Device sem camera dispnonível", systemImage: "x.circle.fill")
                    .foregroundColor(.red)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
            }
        }
    }
    
}

struct FieldCountImageView: View {
    @State private var text = ""

    var onCountChange: (String) -> Void
    var onTimerChange: (Double?) -> Void

    var body: some View {
        TextField("Quantidade de capturas desejadas", text: $text)
            .onChange(of: text) { oldValue, newValue in
                          onCountChange(newValue)
                      }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(.black)
            .padding(.horizontal, 20)
        
        TextField("Intervalo de captura das fotos (em segundos)", text: $text)
            .onChange(of: text) { oldValue, newValue in
                onTimerChange(Double(newValue))
                      }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(.black)
            .padding(.horizontal, 20)
    }
}
