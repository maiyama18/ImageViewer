import SwiftUI

extension UIViewController {
    public func presentImageViewer(dataSource: ImageDataSource) {
        let imageViewerController = ImageViewerController(dataSource: dataSource)
        
        imageViewerController.view.backgroundColor = .clear
        imageViewerController.modalTransitionStyle = .crossDissolve
        imageViewerController.modalPresentationStyle = .overFullScreen
        present(imageViewerController, animated: true)
    }
    
    func hostSwiftUIView<Content: View>(_ rootView: Content) {
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        view.addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        hostingVC.view.pinEdgesToSuperView()
    }
}
