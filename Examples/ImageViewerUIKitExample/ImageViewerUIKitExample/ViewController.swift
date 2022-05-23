//
//  ViewController.swift
//  ImageViewerUIKitExample
//
//  Created by maiyama on 2022/05/21.
//

import SwiftUI
import ImageViewer

class ViewController: UIViewController {
    private let assetImageNames: [String] = ["asakusa", "geometric"]
    
    private let networkImageURLs: [String] = [
        "https://picsum.photos/id/870/300/300",
        "https://picsum.photos/id/871/300/300",
        "https://picsum.photos/id/872/300/300",
        "https://picsum.photos/id/873/300/300"
    ]
    
    @IBOutlet weak var assetImagesStackView: UIStackView! {
        didSet {
            for i in assetImageNames.indices {
                let name = assetImageNames[i]
                
                let imageView = createStackImageView(in: assetImagesStackView)
                
                imageView.image = UIImage(named: name)
                
                let recognizer = IndexedUITapGestureRecognizer(
                    target: self,
                    action: #selector(didTapAssetImage(_:)),
                    index: i
                )
                imageView.addGestureRecognizer(recognizer)
            }
        }
    }
    
    @IBOutlet weak var networkImagesStackView: UIStackView! {
        didSet {
            for i in networkImageURLs.indices {
                let url = networkImageURLs[i]
                if let imageData = try? Data(contentsOf: URL(string: url)!) {
                    let imageView = createStackImageView(in: networkImagesStackView)
                    
                    imageView.image = UIImage(data: imageData)!
                    
                    let recognizer = IndexedUITapGestureRecognizer(
                        target: self,
                        action: #selector(didTapNetworkImage(_:)),
                        index: i
                    )
                    imageView.addGestureRecognizer(recognizer)
                }
            }
        }
    }
    
    @objc func didTapAssetImage(_ sender: IndexedUITapGestureRecognizer) {
        presentImageViewer(
            dataSources: assetImageNames.map { .uiImage(UIImage(named: $0)!) },
            initialIndex: sender.index
        )
    }
    
    @objc func didTapNetworkImage(_ sender: IndexedUITapGestureRecognizer) {
        presentImageViewer(
            dataSources: networkImageURLs.map { .url(URL(string: $0)) },
            initialIndex: sender.index
        )
    }
    
    func createStackImageView(in stackView: UIStackView) -> UIImageView {
        let imageSize = stackView.bounds.height
        
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        stackView.addArrangedSubview(imageView)
        
        return imageView
    }
}

class IndexedUITapGestureRecognizer: UITapGestureRecognizer {
    let index: Int
    
    init(target: Any?, action: Selector?, index: Int) {
        self.index = index
        super.init(target: target, action: action)
    }
}
