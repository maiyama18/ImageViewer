import SwiftUI
import ImageViewer

struct ContentView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        image
            .frame(width: 200, height: 200)
            .onTapGesture {
                isPresented = true
            }
            .imageViewer(isPresented: $isPresented, image: image)
    }
    
    private var image: some View {
        Image(systemName: "sun.min")
            .resizable()
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
    }
}
