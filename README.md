# ImageViewer

:warning: **This package is under developing and currently not production ready. It has problems of crashes and bad performance.**

Yet another simple image viewer for iOS Applications, that is available for both UIKit and SwiftUI.

![image_viewer](https://user-images.githubusercontent.com/22269397/169675704-a5f4001b-01e2-4109-b3a1-1dcdb42de845.gif)

## Installation

Please install using Swift Package Manager by the following URL.

```
https://github.com/maiyama18/ImageViewer.git
```

## Usage

### From UIKit

[Example project](https://github.com/maiyama18/ImageViewer/tree/main/Examples/ImageViewerSwiftUIExample/ImageViewerSwiftUIExample)

```swift
import ImageViewer

final class ViewController: UIViewController {
    @IBAction func didTapNetworkImageButton(_ sender: UIButton) {
        // network image
        presentImageViewer(
            url: URL(string: "https://url/to/network/image"),
            placeholder: { Color.gray }
        )
    }
    
    @IBAction func didTapUIImageButton(_ sender: UIButton) {
        // asset image
        presentImageViewer(
            image: UIImage(named: "my_asset")!
        )
    }
}
```

### From SwiftUI

[Example project](https://github.com/maiyama18/ImageViewer/tree/main/Examples/ImageViewerSwiftUIExample)

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
                url: URL(string: "https://url/to/network/image"),
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
            url: URL(string: "https://url/to/network/image"),
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
