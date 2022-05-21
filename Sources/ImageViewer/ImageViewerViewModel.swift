import Combine
import SwiftUI

class ImageViewerViewModel: NSObject, ObservableObject {
    @Published var imageScale: CGFloat = 1
    @Published var imagePreviousScale: CGFloat = 1
    
    @Published var isClosing: Bool = false
    
    @Published var offsetY: CGFloat = 0
    @Published var initialOffsetY: CGFloat?
    private let offsetYThreshold: CGFloat = 120
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    private let closeRelay: PassthroughSubject<Void, Never> = .init()
    var close: AnyPublisher<Void, Never> { closeRelay.eraseToAnyPublisher() }
    
    var backgroundOpacity: CGFloat {
        guard !isClosing else { return 0 }
        guard imageScale == 1 else { return 1 }
        
        return max(0, 1 - 0.5 * (abs(offsetY) / offsetYThreshold))
    }
    
    func onAppeared() {
        initialize()
        addPanGestureRecognizer()
    }
    
    func onDisappeared() {
        removePanGestureRecognizer()
    }
    
    func onOffsetInitialized(_ value: CGFloat) {
        
    }
    
    func onOffsetChanged(_ value: CGFloat) {
        guard let initialOffsetY = initialOffsetY else { return }
        offsetY = value - initialOffsetY
    }
    
    func onMagnificationChanged(_ value: CGFloat) {
        imageScale = imagePreviousScale * value
    }
    
    func onMagnificationEnded() {
        if imageScale < 1 {
            withAnimation(.easeOut(duration: 0.3)) { imageScale = 1 }
        }
        imagePreviousScale = imageScale
    }
    
    private func rootViewController() -> UIViewController? {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = screen.windows.first?.rootViewController else {
            return nil
        }
        return rootVC
    }
    
    @objc
    private func onGestureChange(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .cancelled || recognizer.state == .ended {
            guard imageScale == 1 else { return }
            
            let v = recognizer.velocity(in: rootViewController()?.view)
            if abs(offsetY) > offsetYThreshold || abs(v.y) > 1000 {
                
                isClosing = true
                withAnimation(.linear(duration: 0.2)) {
                    imageScale = 0
                }
                closeRelay.send(())
            }
        }
    }
    
    private func initialize() {
        isClosing = false
        imageScale = 1
    }
    
    private func addPanGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(recognizer:)))
        recognizer.delegate = self
        rootViewController()?.view.addGestureRecognizer(recognizer)
        
        self.panGestureRecognizer = recognizer
    }
    
    private func removePanGestureRecognizer() {
        rootViewController()?.view.gestureRecognizers?.removeAll(where: { $0 == self.panGestureRecognizer })
    }
}

extension ImageViewerViewModel: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
