import SwiftUI

public final class ImageViewerController: UIViewController {
    private let dataSource: ImageDataSource
    
    public init(dataSource: ImageDataSource) {
        self.dataSource = dataSource
        
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
                dataSource: dataSource
            )
        )
    }
}
