//
//  CircularImageView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 26/01/2024.
//

import UIKit
class CircularImageView: UIView {
    private var imageView: UIImageView?
    var onTap: (() -> Void)!
    
    init(width: CGFloat, height: CGFloat, image: UIImage,imageWidth: CGFloat, imageHeight: CGFloat, imageColor: UIColor? = nil,fillColor: UIColor = .white, onTap: @escaping (() -> Void)) {
        super.init(frame: .zero)
        self.backgroundColor = fillColor
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.onTap = onTap
        translatesAutoresizingMaskIntoConstraints = false

        setupImageView(image: image, imageColor: imageColor,imageWidth: imageWidth, imageHeight: imageHeight)
        setupTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupImageView(image: UIImage, imageColor: UIColor?,imageWidth: CGFloat, imageHeight: CGFloat) {
        let minDimension = min(self.bounds.width, self.bounds.height)
        self.layer.cornerRadius = minDimension / 2
        self.layer.borderColor = UIColor.grey_400.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
        
        let coloredImage = imageColor != nil ? image.withRenderingMode(.alwaysOriginal).withTintColor(imageColor!) : image

        imageView = UIImageView(image: coloredImage)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
//        imageView?.contentMode = .scaleAspectFill // Changed to scaleAspectFill for a better fit

        if let imageView = imageView {
            self.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: imageWidth),
                imageView.heightAnchor.constraint(equalToConstant: imageHeight)
            ])
        }
    }
    
//    func updateImage(image: UIImage,imageColor: UIColor? = nil) {
//        setupImageView(image: image, imageColor: imageColor)
//    }
    

    override var frame: CGRect {
        didSet {
            let minDimension = min(self.bounds.width, self.bounds.height)
            self.layer.cornerRadius = minDimension / 2
        }
    }
    
    private func setupTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapRecognizer)
    }

    @objc private func handleTap() {
        onTap()
    }
    
    // Method to disable the view
      func disable() {
          self.isUserInteractionEnabled = false
          self.alpha = 0.5  // Reduce opacity to visually indicate that it is disabled
      }

      // Method to enable the view
      func enable() {
          self.isUserInteractionEnabled = true
          self.alpha = 1.0  // Restore opacity to full to indicate that it is active
      }
}
