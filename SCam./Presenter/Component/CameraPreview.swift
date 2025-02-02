import SwiftUI

struct CameraPreview: View {
    
    @State private var viewModel = CameraViewModel()
    
    var body: some View {
        CameraView(cameraViewModel: viewModel)
    }
}


#Preview{
    CameraPreview()
}
