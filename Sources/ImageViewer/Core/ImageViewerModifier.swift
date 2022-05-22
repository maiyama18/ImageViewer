import SwiftUI

struct ImageViewerModifier: ViewModifier {
    @Binding var isPresented: Bool
    var dataSource: ImageDataSource
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            ImageViewer(isPresented: $isPresented, dataSource: dataSource)
        }
    }
}
