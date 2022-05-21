import SwiftUI

public final class ImageViewerController<I: View>: UIViewController {
    private let image: I
    
    public init(image: () -> I) {
        self.image = image()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hostSwiftUIView(ImageViewer(isPresented: .constant(true), image: image))
    }
}
