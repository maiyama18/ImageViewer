import SwiftUI

extension View {
    public func imageViewer(isPresented: Binding<Bool>, dataSource: ImageDataSource) -> some View {
        modifier(ImageViewerModifier(isPresented: isPresented, dataSource: dataSource))
    }
}
