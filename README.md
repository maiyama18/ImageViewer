# ImageViewer

Yet another simple image viewer for iOS Application, that is available for both UIKit and SwiftUI. 

## Installation

Please install using Swift Package Manager by the following URL.

```
https://github.com/maiyama18/ImageViewer.git
```

## Usage

### From UIKit

```swift
final class ViewController: UIViewController {
    @IBAction func didTapNetworkImageButton(_ sender: UIButton) {
        // network image
        presentImageViewer(
            url: URL(string: "https://picsum.photos/id/870/300/300"),
            placeholder: { Color.gray }
        )
    }
    
    @IBAction func didTapUIImageButton(_ sender: UIButton) {
        // asset image
        presentImageViewer(
            image: UIImage(named: "geometric")!
        )
    }
}
```

### From SwiftUI

**The use from SwiftUI is currently unstable and sometimes not working correctly.**

```swift
struct ContentView: View {
    @State private var isSystemImagePresented: Bool = false
    @State private var isNetworkImagePresented: Bool = false
    
    var body: some View {
        VStack {
            // system image
            image
                .frame(width: 200, height: 200)
                .onTapGesture {
                    isSystemImagePresented = true
                }
            
            // network image
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
        .imageViewer(isPresented: $isSystemImagePresented, image: image)
        .imageViewer(
            isPresented: $isNetworkImagePresented,
            url: URL(string: "https://picsum.photos/id/870/300/300"),
            placeholder: { Color.gray.opacity(0.25) }
        )
    }
    
    private var image: some View {
        Image(systemName: "sun.min")
            .resizable()
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
    }
}
```
