//
//  TitleLabel.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/12/2023.
//

import UIKit
class TitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text:String,textAlignment: NSTextAlignment, fontSize: CGFloat,fontWeight: UIFont.Weight = .regular,textColor: UIColor = .black) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor = textColor
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
    
}
