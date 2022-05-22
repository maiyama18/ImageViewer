import SwiftUI

struct ImageViewer: View {
    @Binding var isPresented: Bool
    var dataSource: ImageDataSource
    
    var body: some View {
        Group {
            if isPresented {
                ZStack(alignment: .top) {
                    ScrollableImageView(
                        dataSource: dataSource,
                        onCloseConditionSatisfied: {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    )
                        .ignoresSafeArea()
                }
            }
        }
    }
}
