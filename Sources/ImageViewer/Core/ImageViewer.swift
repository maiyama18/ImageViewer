import SwiftUI
import Combine

struct ImageViewer: View {
    @Binding var isPresented: Bool
    var dataSources: [ImageDataSource]
    var initialIndex: Int
    
    init(isPresented: Binding<Bool>, dataSources: [ImageDataSource], initialIndex: Int) {
        self._isPresented = isPresented
        self.dataSources = dataSources
        self.initialIndex = initialIndex
    }
    
    @State private var backgroundOpacity: CGFloat = 1
    
    @State private var currentDataSourceID: String = ""
    
    @State private var isShareViewPresented: Bool = false
    @State private var shareItems: [Any] = []
    
    private let imageChangedSubject: PassthroughSubject<Void, Never> = .init()
    
    var body: some View {
        Group {
            if isPresented {
                ZStack(alignment: .top) {
                    VStack {
                        TabView(selection: $currentDataSourceID) {
                            ForEach(dataSources) { dataSource in
                                ScrollableImageView(
                                    dataSource: dataSource,
                                    onCloseConditionSatisfied: {
                                        withAnimation(.linear(duration: 0.2)) {
                                            isPresented = false
                                        }
                                    },
                                    onOffsetToThresholdRatioChanged: { ratio in
                                        backgroundOpacity = max(0, 1 - 0.3 * ratio)
                                    },
                                    imageChangedPublisher: imageChangedSubject.eraseToAnyPublisher()
                                )
                                .tag(dataSource.id)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                    }
                    .background(Color.black.opacity(backgroundOpacity))
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
                            guard let dataSource = dataSources.first(where: { $0.id == currentDataSourceID }) else { return }
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
        .onAppear {
            currentDataSourceID = dataSources[initialIndex].id
        }
        .onChange(of: currentDataSourceID) { id in
            imageChangedSubject.send(())
        }
    }
}
