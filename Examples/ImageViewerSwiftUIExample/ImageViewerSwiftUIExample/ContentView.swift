import SwiftUI
import ImageViewer

struct ContentView: View {
    @State private var isImagePresented: Bool = false
    @State private var isAsyncImagePresented: Bool = false
    
    var body: some View {
        VStack {
            image
                .frame(width: 200, height: 200)
                .onTapGesture {
                    isImagePresented = true
                }
            
            AsyncImage(
                url: URL(string: "https://picsum.photos/id/870/300/300"),
                content: { $0.resizable() },
                placeholder: { Color.gray.opacity(0.25) }
            )
            .frame(width: 200, height: 200)
            .onTapGesture {
                isAsyncImagePresented = true
            }
        }
        .imageViewer(isPresented: $isImagePresented, image: image)
        .imageViewer(isPresented: $isAsyncImagePresented, url: URL(string: "https://picsum.photos/id/870/300/300"))
    }
    
    private var image: some View {
        Image(systemName: "sun.min")
            .resizable()
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
    }
}
