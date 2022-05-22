import SwiftUI
import ImageViewer

struct ContentView: View {
    @State private var isAssetImagePresented: Bool = false
    @State private var isNetworkImagePresented: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("asset image")
                    .bold()
                Image(uiImage: UIImage(named: "asakusa")!).resizable()
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        isAssetImagePresented = true
                    }
            }
            
            VStack(spacing: 4) {
                Text("network image")
                    .bold()
                AsyncImage(
                    url: URL(string: "https://picsum.photos/id/870/300/300"),
                    content: { $0.resizable() },
                    placeholder: { Color.gray.opacity(0.25) }
                )
                .frame(width: 200, height: 200)
                .onTapGesture {
                    isNetworkImagePresented = true
                }
            }
        }
        .imageViewer(isPresented: $isAssetImagePresented, dataSource: .uiImage(UIImage(named: "asakusa")!))
        .imageViewer(
            isPresented: $isNetworkImagePresented,
            dataSource: .url(URL(string: "https://picsum.photos/id/870/300/300"))
        )
    }
}
