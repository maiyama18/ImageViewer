import SwiftUI

extension View {
    public func imageViewer<I: View>(isPresented: Binding<Bool>, image: I) -> some View {
        modifier(ImageViewerModifier(isPresented: isPresented, image: image))
    }
    
    @available(iOS 15.0, *)
    public func imageViewer<P: View>(isPresented: Binding<Bool>, url: URL?, placeholder: @escaping () -> P) -> some View {
        let image = AsyncImage(url: url, content: { $0.resizable() }, placeholder: placeholder)
        return modifier(ImageViewerModifier(isPresented: isPresented, image: image))
    }
}
