import SwiftUI

struct ImageViewerModifier<I: View>: ViewModifier {
    @Binding var isPresented: Bool
    var image: I
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            ImageViewer(isPresented: $isPresented, image: image)
        }
    }
}
