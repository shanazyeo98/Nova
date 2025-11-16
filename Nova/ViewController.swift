//
//  ViewController.swift
//  Nova
//
//  Created by Shanaz Yeo on 15/11/25.
//

import UIKit
import Gifu

class ViewController: UIViewController {
    
    let jarAspectRatio: CGFloat = 1668 / 2388
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
    
    let addStarButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.tintColor = .systemCyan
        button.setTitle("Add Star", for: .normal)
        return button
    }()
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var itemBehaviour: UIDynamicItemBehavior!
    
    var didSetupJarBoundaries: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPhysicsEngine()
//        setupJarBoundaries()
//        addStar()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didSetupJarBoundaries { return }
        didSetupJarBoundaries = true
        setupJarBoundaries()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(jarBackGIFView)
        view.addSubview(jarFrontGIFView)
        addStarButton.addTarget(self, action: #selector(addStar), for: .touchUpInside)
        view.addSubview(addStarButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            jarBackGIFView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: jarHeightMultiplier),
            jarBackGIFView.widthAnchor.constraint(equalTo: jarBackGIFView.heightAnchor, multiplier: jarAspectRatio),
            jarBackGIFView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jarBackGIFView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            jarFrontGIFView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: jarHeightMultiplier),
            jarFrontGIFView.widthAnchor.constraint(equalTo: jarFrontGIFView.heightAnchor, multiplier: jarAspectRatio),
            jarFrontGIFView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jarFrontGIFView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addStarButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            addStarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupPhysicsEngine() {
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior()
        gravity.magnitude = 1.5
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = false
        animator.addBehavior(collision)
        
        itemBehaviour = UIDynamicItemBehavior()
        itemBehaviour.elasticity = 0.2
        itemBehaviour.friction = 0.8
        itemBehaviour.allowsRotation = true
        animator.addBehavior(itemBehaviour)
    }
    
    func setupJarBoundaries() {
        let jarFrame = jarBackGIFView.frame
        //Left wall
        collision.addBoundary(withIdentifier: "left" as NSString, from: CGPoint(x: jarFrame.minX + 20, y: jarFrame.minY + 50), to: CGPoint(x: jarFrame.minX + 20, y: jarFrame.maxY - 15))
        
        //Right wall
        collision.addBoundary(withIdentifier: "right" as NSString, from: CGPoint(x: jarFrame.maxX - 20, y: jarFrame.minY + 50), to: CGPoint(x: jarFrame.maxX - 20, y: jarFrame.maxY - 15))
        
        //Bottom
        collision.addBoundary(withIdentifier: "bottom" as NSString, from: CGPoint(x: jarFrame.minX + 50, y: jarFrame.maxY - 15), to: CGPoint(x: jarFrame.maxX - 50, y: jarFrame.maxY - 15))
    }
    
    func animate() {
        jarBackGIFView.animate(withGIFNamed: "jar_back")
        jarFrontGIFView.animate(withGIFNamed: "jar_front")
    }
    
    @objc func addStar() {
        let star = GIFImageView()
//        star.translatesAutoresizingMaskIntoConstraints = false
//        star.contentMode = .scaleAspectFit
        
//        let jarWidth = jarBackGIFView.frame.width - 20
        let jarMinX = jarBackGIFView.frame.minX + 60
        let jarMaxX = jarBackGIFView.frame.maxX - 60
        let starXPosition = CGFloat.random(in: jarMinX...jarMaxX)
        
        star.frame = CGRect(x: starXPosition,
                                    y: 0,
                                    width: 50,
                                    height: 50)
        
        view.insertSubview(star, belowSubview: jarBackGIFView)
        star.animate(withGIFNamed: "star")
        
        gravity.addItem(star)
        collision.addItem(star)
        itemBehaviour.addItem(star)
    }
    
}

#Preview {
    ViewController()
}
