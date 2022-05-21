import SwiftUI

extension UIViewController {
    public func presentImageViewer<I: View>(image: () -> I) {
        let imageViewerController = ImageViewerController(image: image)
        present(imageViewerController: imageViewerController)
    }
    
    @available(iOS 15.0, *)
    public func presentImageViewer<P: View>(url: URL?, placeholder: @escaping () -> P) {
        let imageViewerController = ImageViewerController(image: {
            AsyncImage(url: url, content: { $0.resizable() }, placeholder: placeholder)
        })
        present(imageViewerController: imageViewerController)
    }
    
    @available(iOS 15.0, *)
    public func presentImageViewer(url: URL?, placeholder: UIImage) {
        let imageViewerController = ImageViewerController(image: {
            AsyncImage(url: url, content: { $0.resizable() }, placeholder: { Image(uiImage: placeholder).resizable() })
        })
        present(imageViewerController: imageViewerController)
    }
    
    func hostSwiftUIView<Content: View>(_ rootView: Content) {
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        view.addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        hostingVC.view.pinEdgesToSuperView()
    }
    
    private func present<I: View>(imageViewerController: ImageViewerController<I>) {
        imageViewerController.view.backgroundColor = .clear
        imageViewerController.modalTransitionStyle = .crossDissolve
        imageViewerController.modalPresentationStyle = .overFullScreen
        present(imageViewerController, animated: true)
    }
}
