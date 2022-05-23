import SwiftUI
import ImageViewer

struct ContentView: View {
    @State private var isAssetImagePresented: Bool = false
    @State private var assetImageIndex: Int = 0
    @State private var isNetworkImagePresented: Bool = false
    @State private var networkImageIndex: Int = 0
    
    private let assetImageNames: [String] = ["asakusa", "geometric"]
        
    private let networkImageURLs: [String] = [
        "https://picsum.photos/id/870/300/300",
        "https://picsum.photos/id/871/300/300",
        "https://picsum.photos/id/872/300/300",
        "https://picsum.photos/id/873/300/300"
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("asset image")
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(assetImageNames, id: \.self) { name in
                            Image(uiImage: UIImage(named: name)!).resizable()
                                .frame(width: 200, height: 200)
                                .onTapGesture {
                                    assetImageIndex = assetImageNames.firstIndex(of: name) ?? 0
                                    isAssetImagePresented = true
                                }
                        }
                    }
                }
            }
            
            VStack(spacing: 4) {
                Text("network image")
                    .bold()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(networkImageURLs, id: \.self) { url in
                            AsyncImage(
                                url: URL(string: url),
                                content: { $0.resizable() },
                                placeholder: { Color.gray.opacity(0.25) }
                            )
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                networkImageIndex = networkImageURLs.firstIndex(of: url) ?? 0
                                isNetworkImagePresented = true
                            }
                        }
                    }
                }
            }
        }
        .imageViewer(
            isPresented: $isAssetImagePresented,
            dataSources: assetImageNames.map { .uiImage(UIImage(named: $0)!) },
            initialIndex: assetImageIndex
        )
        .imageViewer(
            isPresented: $isNetworkImagePresented,
            dataSources: networkImageURLs.map { .url(URL(string: $0)) },
            initialIndex: networkImageIndex
        )
    }
}
