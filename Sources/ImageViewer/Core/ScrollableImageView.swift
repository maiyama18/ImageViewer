import SwiftUI
import Combine

struct ScrollableImageView: UIViewRepresentable {
    var dataSource: ImageDataSource
    var onCloseConditionSatisfied: () -> Void
    var onOffsetToThresholdRatioChanged: (Double) -> Void
    var imageChangedPublisher: AnyPublisher<Void, Never>
    
    @State var scrollView: UIScrollView?

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = context.coordinator.scrollView
        scrollView.delegate = context.coordinator

        let imageView = context.coordinator.imageView
        imageView.frame = scrollView.bounds
        
        scrollView.addSubview(imageView)
        
        return scrollView
    }

    func makeCoordinator() -> Coordinator {
        let scrollView = UIScrollView()
        
        scrollView.backgroundColor = .clear
        scrollView.maximumZoomScale = 12
        scrollView.minimumZoomScale = 1
        scrollView.alwaysBounceVertical = true
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
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
        
        return Coordinator(
            scrollView: scrollView,
            imageView: imageView,
            imageChangedPublisher: imageChangedPublisher,
            onCloseConditionSatisfied: onCloseConditionSatisfied,
            onOffsetToThresholdRatioChanged: onOffsetToThresholdRatioChanged
        )
    }

    func updateUIView(_: UIScrollView, context _: Context) {}

    class Coordinator: NSObject, UIScrollViewDelegate {
        var scrollView: UIScrollView
        var imageView: UIImageView
        var onCloseConditionSatisfied: () -> Void
        var onOffsetToThresholdRatioChanged: (Double) -> Void
    
        private var cancellables: [AnyCancellable] = []

        init(
            scrollView: UIScrollView,
            imageView: UIImageView,
            imageChangedPublisher: AnyPublisher<Void, Never>,
            onCloseConditionSatisfied: @escaping () -> Void,
            onOffsetToThresholdRatioChanged: @escaping (Double) -> Void
        ) {
            self.scrollView = scrollView
            self.imageView = imageView
            self.onCloseConditionSatisfied = onCloseConditionSatisfied
            self.onOffsetToThresholdRatioChanged = onOffsetToThresholdRatioChanged
            
            imageChangedPublisher
                .receive(on: DispatchQueue.main)
                .sink {
                    UIView.animate(withDuration: 0.3) {
                        scrollView.zoomScale = 1
                    }
                }
                .store(in: &cancellables)
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
            onOffsetToThresholdRatioChanged(scrollOffset / 120)
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
