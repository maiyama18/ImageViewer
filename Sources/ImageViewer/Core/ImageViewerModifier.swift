import SwiftUI

struct ImageViewerModifier: ViewModifier {
    @Binding var isPresented: Bool
    var dataSources: [ImageDataSource]
    var initialIndex: Int
    
    init(isPresented: Binding<Bool>, dataSources: [ImageDataSource], initialIndex: Int) {
        self._isPresented = isPresented
        self.dataSources = dataSources
        self.initialIndex = initialIndex
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            ImageViewer(
                isPresented: $isPresented,
                dataSources: dataSources,
                initialIndex: initialIndex
            )
        }
    }
}
