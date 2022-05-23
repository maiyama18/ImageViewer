import SwiftUI

extension UIViewController {
    public func presentImageViewer(dataSources: [ImageDataSource], initialIndex: Int = 0) {
        let imageViewerController = ImageViewerController(dataSources: dataSources, initialIndex: initialIndex)
        
        imageViewerController.view.backgroundColor = .clear
        imageViewerController.modalTransitionStyle = .crossDissolve
        imageViewerController.modalPresentationStyle = .overFullScreen
        present(imageViewerController, animated: true)
    }
    
    func hostSwiftUIView<Content: View>(_ rootView: Content, hostingViewBackgroundColor: UIColor = .systemBackground) {
        let hostingVC = UIHostingController(rootView: rootView)
        hostingVC.view.backgroundColor = hostingViewBackgroundColor
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        view.addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        hostingVC.view.pinEdgesToSuperView()
    }
}
