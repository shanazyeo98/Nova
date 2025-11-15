//
//  ViewController.swift
//  Nova
//
//  Created by Shanaz Yeo on 15/11/25.
//

import UIKit
import Gifu

class ViewController: UIViewController {
    
    let jarHeightMultiplier: CGFloat = 0.55
    
    let jarBackGIFView = {
        let imageView = GIFImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let jarFrontGIFView = {
        let imageView = GIFImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animate()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(jarBackGIFView)
        view.addSubview(jarFrontGIFView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            jarBackGIFView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: jarHeightMultiplier),
            jarBackGIFView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jarBackGIFView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            jarFrontGIFView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: jarHeightMultiplier),
            jarFrontGIFView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jarFrontGIFView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func animate() {
        jarBackGIFView.animate(withGIFNamed: "jar_back")
        jarFrontGIFView.animate(withGIFNamed: "jar_front")
    }
    
}

#Preview {
    ViewController()
}
