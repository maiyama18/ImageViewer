import SwiftUI

struct ImageViewer<I: View>: View {
    @Binding var isPresented: Bool
    var image: I
    
    @StateObject private var viewModel: ImageViewerViewModel = .init()
    
    private let scrollViewCoordinateSpace = "ScrollViewCoordinateSpace"
    
    var body: some View {
        Group {
            if isPresented {
                ZStack {
                    background
                    
                    imageScrollView
                        .onAppear { viewModel.onAppeared() }
                        .onDisappear { viewModel.onDisappeared() }
                        .onReceive(viewModel.close) {
                            withAnimation(.easeInOut(duration: 0.2).delay(0.1)) {
                                isPresented = false
                            }
                        }
                }
                .overlay(topButtonsOverlay)
                .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            }
        }
    }
    
    private var background: some View {
        Color.black
            .opacity(viewModel.backgroundOpacity)
            .ignoresSafeArea()
    }
    
    private var imageScrollView: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            image
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.size.width * viewModel.imageScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            viewModel.onMagnificationChanged(value)
                        }
                        .onEnded { _ in
                            viewModel.onMagnificationEnded()
                        }
                )
                .overlay(
                    Rectangle()
                        .fill(.clear)
                        .background(
                            GeometryReader { proxy in
                                let offsetY = proxy.frame(in: .named(scrollViewCoordinateSpace)).origin.y + 0.5 * proxy.size.height
                                Color.clear
                                    .preference(key: ViewOffsetYKey.self, value: offsetY)
                                    .onAppear {
                                        viewModel.onOffsetInitialized(offsetY)
                                    }
                            }
                        )
                )
        }
        .onPreferenceChange(ViewOffsetYKey.self) {
            viewModel.onOffsetChanged($0)
        }
        .coordinateSpace(name: scrollViewCoordinateSpace)
    }
    
    private var topButtonsOverlay: some View {
        HStack {
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.body.bold())
                    .padding(24)
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct ViewOffsetYKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
