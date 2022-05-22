import SwiftUI

extension UIImage: Identifiable {}

struct ImageViewer: View {
    @Binding var isPresented: Bool
    var dataSource: ImageDataSource
    
    @State private var isShareViewPresented: Bool = false
    @State private var shareItems: [Any] = []
    
    var body: some View {
        Group {
            if isPresented {
                ZStack(alignment: .top) {
                    ScrollableImageView(
                        dataSource: dataSource,
                        onCloseConditionSatisfied: {
                            withAnimation(.linear(duration: 0.5).delay(0.1)) {
                                isPresented = false
                            }
                        }
                    )
                        .ignoresSafeArea()
                    
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                            
                        Button(action: {
                            switch dataSource {
                            case .url(let url):
                                guard let url = url else { return }
                                URLSession.shared.dataTask(with: url) { data, _, error in
                                    guard let data = data, let uiImage = UIImage(data: data) else {
                                        print(error ?? "unknown error")
                                        return
                                    }
                                    shareItems = [uiImage]
                                    isShareViewPresented = true
                                }.resume()
                            case .uiImage(let uIImage):
                                shareItems = [uIImage]
                                isShareViewPresented = true
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShareViewPresented) {
            ShareView(items: shareItems)
        }
    }
}
