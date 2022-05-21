import SwiftUI

extension View {
    public func imageViewer<I: View>(isPresented: Binding<Bool>, image: I) -> some View {
        modifier(ImageViewerModifier(isPresented: isPresented, image: image))
    }
}
