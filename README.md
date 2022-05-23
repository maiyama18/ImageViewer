# ImageViewer

Yet another simple image viewer for iOS Applications.

![ImageViewer](https://user-images.githubusercontent.com/22269397/169911938-d1011ab1-72b3-4391-a180-8bec750837ea.gif)

## Installation

Please install by Swift Package Manager using the following URL.

```
https://github.com/maiyama18/ImageViewer.git
```

## Usage

### From UIKit

[Example project](https://github.com/maiyama18/ImageViewer/tree/main/Examples/ImageViewerSwiftUIExample/ImageViewerSwiftUIExample)

```swift
import ImageViewer

final class ViewController: UIViewController {
    func showImages() {
        presentImageViewer(
            dataSources: [
                .url("https://your/url.to.image"), // network image
                .uiImage("your asset name") // asset image
            ],
            initialIndex: 0
        )
    }
}
```

### From SwiftUI

**Use from SwiftUI is under developing and currently unstable. It's not working well in some situations.**

[Example project](https://github.com/maiyama18/ImageViewer/tree/main/Examples/ImageViewerSwiftUIExample)

```swift
struct ContentView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            // ...
        }
        .imageViewer(
            isPresented: $isPresented,
            dataSources: [
                .url("https://your/url.to.image"), // network image
                .uiImage("your asset name") // asset image
            ],
            initialIndex: 1 
        )
    }
}
```
