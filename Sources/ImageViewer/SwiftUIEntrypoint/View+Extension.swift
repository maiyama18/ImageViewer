import SwiftUI

extension View {
    public func imageViewer(
        isPresented: Binding<Bool>,
        dataSources: [ImageDataSource],
        initialIndex: Int = 0
    ) -> some View {
        modifier(ImageViewerModifier(isPresented: isPresented, dataSources: dataSources, initialIndex: initialIndex))
    }
}
