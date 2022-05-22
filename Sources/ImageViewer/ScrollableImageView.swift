import SwiftUI

struct ScrollableImageView: UIViewRepresentable {
    var dataSource: ImageDataSource
    var onCloseConditionSatisfied: () -> Void

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.backgroundColor = .black
        scrollView.maximumZoomScale = 12
        scrollView.minimumZoomScale = 1
        scrollView.alwaysBounceVertical = true
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        let imageView = context.coordinator.imageView
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
        return scrollView
    }

    func makeCoordinator() -> Coordinator {
        let imageView = UIImageView()
        switch dataSource {
        case .url(let url):
            if let url = url, let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        case .uiImage(let uIImage):
            imageView.image = uIImage
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return Coordinator(imageView: imageView, onCloseConditionSatisfied: onCloseConditionSatisfied)
    }

    func updateUIView(_: UIScrollView, context _: Context) {}

    class Coordinator: NSObject, UIScrollViewDelegate {
        var imageView: UIImageView
        var onCloseConditionSatisfied: () -> Void

        init(imageView: UIImageView, onCloseConditionSatisfied: @escaping () -> Void) {
            self.imageView = imageView
            self.onCloseConditionSatisfied = onCloseConditionSatisfied
        }

        func viewForZooming(in _: UIScrollView) -> UIView? {
            imageView
        }

        func scrollViewDidZoom(_: UIScrollView) {
            centerImage()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard scrollView.zoomScale == 1 else { return }
            let scrollOffset = abs(scrollView.contentOffset.y)
            let alpha = max(0, 1 - (scrollOffset / 300))
            scrollView.backgroundColor = .black.withAlphaComponent(alpha)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            guard scrollView.zoomScale == 1 else { return }
            
            let scrollOffset = abs(scrollView.contentOffset.y)
            let velocity = abs(scrollView.panGestureRecognizer.velocity(in: scrollView).y)
            
            if scrollOffset > 150 || velocity > 1000 {
                UIView.animate(withDuration: 0.2) {
                    self.imageView.bounds = .init(x: 0, y: 0, width: 10, height: 10)
                }
                onCloseConditionSatisfied()
            }
        }

        func centerImage() {
            let boundsSize = imageView.bounds.size
            var frameToCenter = imageView.frame

            if frameToCenter.size.width < boundsSize.width {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
            } else {
                frameToCenter.origin.x = 0
            }

            if frameToCenter.size.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
            } else {
                frameToCenter.origin.y = 0
            }

            imageView.frame = frameToCenter
        }
    }
}
