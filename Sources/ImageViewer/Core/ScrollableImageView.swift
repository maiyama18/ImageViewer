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
            if let url = url {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: data)
                        }
                    } else {
                        print(error ?? "unknown error")
                    }
                }.resume()
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
            let boundsSize = imageView.bounds.size
            var frame = imageView.frame
            
            if frame.size.width < boundsSize.width {
                frame.origin.x = (boundsSize.width - frame.size.width) / 2
            } else {
                frame.origin.x = 0
            }
            
            if frame.size.height < boundsSize.height {
                frame.origin.y = (boundsSize.height - frame.size.height) / 2
            } else {
                frame.origin.y = 0
            }

            imageView.frame = frame
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard scrollView.zoomScale == 1 else { return }
            let scrollOffset = abs(scrollView.contentOffset.y)
            let alpha = max(0, 1 - (scrollOffset / 300))
            scrollView.backgroundColor = .black.withAlphaComponent(alpha)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            guard scrollView.zoomScale == 1 else { return }
            
            let scrollOffset = scrollView.contentOffset.y
            let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
            
            guard abs(velocity) < 1000 else {
                // close by velocity
                UIView.animate(withDuration: 0.3) {
                    self.imageView.frame.origin.y += velocity * 0.5
                    self.imageView.alpha = 0
                }
                onCloseConditionSatisfied()
                return
            }
            
            guard abs(scrollOffset) < 120 else {
                // close by offset
                UIView.animate(withDuration: 0.3) {
                    self.imageView.alpha = 0
                }
                onCloseConditionSatisfied()
                return
            }
            
            return
        }
    }
}