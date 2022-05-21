import SwiftUI

extension View {
    public func imageViewer<I: View>(isPresented: Binding<Bool>, image: I) -> some View {
        modifier(ImageViewerModifier(isPresented: isPresented, image: image))
    }
    
    @available(iOS 15.0, *)
    public func imageViewer(isPresented: Binding<Bool>, url: URL?) -> some View {
        let image = AsyncImage(url: url, content: { $0.resizable() }, placeholder: { Color.clear })
        return modifier(ImageViewerModifier(isPresented: isPresented, image: image))
    }
}
