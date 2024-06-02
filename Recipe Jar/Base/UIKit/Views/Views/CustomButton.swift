//
//  CustomButton.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/12/2023.
//

import UIKit
class CustomButton: UIButton {

    var buttonPath: UIBezierPath?
    var buttonColor: UIColor!
    var buttonWidth: CGFloat!
    var buttonHeight: CGFloat!
    var buttonImage: UIImage?
    
//    var buttonRect: CGRect!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    init(buttonPath: UIBezierPath? = nil, buttonColor: UIColor, buttonWidth: CGFloat, buttonHeight: CGFloat,buttonImage: UIImage? = nil) {
        super.init(frame: .zero)

        self.buttonPath = buttonPath
        self.buttonColor = buttonColor
        self.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        self.buttonHeight = buttonHeight
        self.buttonWidth = buttonWidth
        self.buttonImage = buttonImage
        translatesAutoresizingMaskIntoConstraints = false
        
        setupButton()
    }
    // Override intrinsicContentSize to reflect the new width and height
       override var intrinsicContentSize: CGSize {
           return CGSize(width: frame.width, height: frame.height)
       }

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
    
        if let buttonPath = buttonPath {
            // Adjust the origin of the path to (0, 0)
                    let offsetX = -buttonPath.bounds.origin.x
                    let offsetY = -buttonPath.bounds.origin.y
                    buttonPath.apply(CGAffineTransform(translationX: offsetX, y: offsetY))
                    // Calculate the scale factors
                    let scaleFactorX = buttonWidth / buttonPath.bounds.width
                    let scaleFactorY = buttonHeight / buttonPath.bounds.height
                    // Choose the smaller scale factor to ensure the path fits within the button
                    let scaleFactor = max(scaleFactorX, scaleFactorY)
                    // Apply the scale transform
                    buttonPath.apply(CGAffineTransform(scaleX: scaleFactorX, y: scaleFactorY))
                    // Create and configure the shape layer
        
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = buttonPath.cgPath
                    shapeLayer.fillColor = buttonColor.cgColor
                    // Center the shape layer within the button
                    shapeLayer.position = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
                    // Add the shape layer to the button's layer
                    layer.addSublayer(shapeLayer)
                    // Set the shapeLayer's frame to the button's bounds
                    shapeLayer.frame = bounds
      
           }
        else {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: buttonWidth),
                heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
               let imageView = UIImageView()
               imageView.image = buttonImage//.withRenderingMode(.alwaysOriginal).withTintColor(buttonColor)
               imageView.contentMode = .scaleAspectFit
               addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
                   NSLayoutConstraint.activate([
                       imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                       imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                       imageView.topAnchor.constraint(equalTo: topAnchor),
                       imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
                   ])
            
           }
        
    
        
    }
    
    override var isHighlighted: Bool {
          didSet {
              // Adjust the opacity when the button is highlighted
              alpha = isHighlighted ? 0.5 : 1.0
          }
      }
   
}

extension UIBezierPath {
    func scaledToFit(_ rect: CGRect) -> UIBezierPath {
        let boundingBox = self.bounds
        let scaleFactor = min(rect.width / boundingBox.width, rect.height / boundingBox.height)
        let scaledPath = self.copy() as! UIBezierPath
        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        scaledPath.apply(transform)
        return scaledPath
    }
}
