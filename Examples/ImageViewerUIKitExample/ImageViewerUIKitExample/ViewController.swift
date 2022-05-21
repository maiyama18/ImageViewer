//
//  ViewController.swift
//  ImageViewerUIKitExample
//
//  Created by maiyama on 2022/05/21.
//

import SwiftUI
import ImageViewer

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapNetworkImageButton(_ sender: UIButton) {
        presentImageViewer(
            url: URL(string: "https://picsum.photos/id/870/300/300"),
            placeholder: { Color.gray }
        )
    }
    
    @IBAction func didTapUIImageButton(_ sender: UIButton) {
        presentImageViewer(
            image: UIImage(named: "geometric")!
        )
    }
}

