//
//  ViewController.swift
//  ImageViewerUIKitExample
//
//  Created by maiyama on 2022/05/21.
//

import SwiftUI
import ImageViewer

class ViewController: UIViewController {
    @IBOutlet weak var assetImageView: UIImageView! {
        didSet {
            let recognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(didTapAssetImage(_:))
            )
            assetImageView.addGestureRecognizer(recognizer)
        }
    }
    
    @IBOutlet weak var networkImageView: UIImageView! {
        didSet {
            if let imageData = try? Data(contentsOf: URL(string: "https://picsum.photos/id/870/300/300")!) {
                networkImageView.image = UIImage(data: imageData)
            }
            
            let recognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(didTapNetworkImage(_:))
            )
            networkImageView.addGestureRecognizer(recognizer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func didTapAssetImage(_ sender: UITapGestureRecognizer) {
        presentImageViewer(
            dataSource: .uiImage(UIImage(named: "asakusa")!)
        )
    }
    
    @objc func didTapNetworkImage(_ sender: UITapGestureRecognizer) {
        presentImageViewer(
            dataSource: .url(URL(string: "https://picsum.photos/id/870/300/300"))
        )
    }
}

