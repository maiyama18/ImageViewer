import SwiftUI

public final class ImageViewerController: UIViewController {
    private let dataSources: [ImageDataSource]
    private let initialIndex: Int
    
    public init(dataSources: [ImageDataSource], initialIndex: Int) {
        self.dataSources = dataSources
        self.initialIndex = initialIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hostSwiftUIView(
            ImageViewer(
                isPresented: .init(
                    get: { true },
                    set: { [weak self] isPresented in
                        if !isPresented {
                            self?.dismiss(animated: true)
                        }
                    }
                ),
                dataSources: dataSources,
                initialIndex: initialIndex
            ),
            hostingViewBackgroundColor: .clear
        )
    }
}
