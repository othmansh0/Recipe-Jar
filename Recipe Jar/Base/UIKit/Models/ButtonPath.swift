//
//  ButtonPaths.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/12/2023.
//

import UIKit
class ButtonPath {
    static let shared = ButtonPath()
    private init() {}
    
    var sideMenuPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 27.5, y: 24.1))
        path.addCurve(to: CGPoint(x: 28.9, y: 24.6), controlPoint1: CGPoint(x: 28, y: 24.1), controlPoint2: CGPoint(x: 28.5, y: 24.3))
        path.addCurve(to: CGPoint(x: 29.6, y: 26), controlPoint1: CGPoint(x: 29.3, y: 25), controlPoint2: CGPoint(x: 29.5, y: 25.5))
        path.addCurve(to: CGPoint(x: 29.1, y: 27.5), controlPoint1: CGPoint(x: 29.6, y: 26.6), controlPoint2: CGPoint(x: 29.4, y: 27.1))
        path.addCurve(to: CGPoint(x: 27.7, y: 28.2), controlPoint1: CGPoint(x: 28.7, y: 27.9), controlPoint2: CGPoint(x: 28.2, y: 28.1))
        path.addLine(to: CGPoint(x: 27.5, y: 28.2))
        path.addLine(to: CGPoint(x: 5.5, y: 28.2))
        path.addCurve(to: CGPoint(x: 4.1, y: 27.6), controlPoint1: CGPoint(x: 5, y: 28.2), controlPoint2: CGPoint(x: 4.5, y: 28))
        path.addCurve(to: CGPoint(x: 3.4, y: 26.2), controlPoint1: CGPoint(x: 3.7, y: 27.3), controlPoint2: CGPoint(x: 3.5, y: 26.8))
        path.addCurve(to: CGPoint(x: 3.9, y: 24.8), controlPoint1: CGPoint(x: 3.4, y: 25.7), controlPoint2: CGPoint(x: 3.6, y: 25.2))
        path.addCurve(to: CGPoint(x: 5.3, y: 24.1), controlPoint1: CGPoint(x: 4.3, y: 24.4), controlPoint2: CGPoint(x: 4.8, y: 24.1))
        path.addLine(to: CGPoint(x: 5.5, y: 24.1))
        path.addLine(to: CGPoint(x: 27.5, y: 24.1))
        path.close()
        path.move(to: CGPoint(x: 27.5, y: 14.4))
        path.addCurve(to: CGPoint(x: 29, y: 15), controlPoint1: CGPoint(x: 28, y: 14.4), controlPoint2: CGPoint(x: 28.6, y: 14.7))
        path.addCurve(to: CGPoint(x: 29.6, y: 16.5), controlPoint1: CGPoint(x: 29.3, y: 15.4), controlPoint2: CGPoint(x: 29.6, y: 16))
        path.addCurve(to: CGPoint(x: 29, y: 18), controlPoint1: CGPoint(x: 29.6, y: 17), controlPoint2: CGPoint(x: 29.3, y: 17.6))
        path.addCurve(to: CGPoint(x: 27.5, y: 18.6), controlPoint1: CGPoint(x: 28.6, y: 18.3), controlPoint2: CGPoint(x: 28, y: 18.6))
        path.addLine(to: CGPoint(x: 5.5, y: 18.6))
        path.addCurve(to: CGPoint(x: 4, y: 18), controlPoint1: CGPoint(x: 5, y: 18.6), controlPoint2: CGPoint(x: 4.4, y: 18.3))
        path.addCurve(to: CGPoint(x: 3.4, y: 16.5), controlPoint1: CGPoint(x: 3.7, y: 17.6), controlPoint2: CGPoint(x: 3.4, y: 17))
        path.addCurve(to: CGPoint(x: 4, y: 15), controlPoint1: CGPoint(x: 3.4, y: 16), controlPoint2: CGPoint(x: 3.7, y: 15.4))
        path.addCurve(to: CGPoint(x: 5.5, y: 14.4), controlPoint1: CGPoint(x: 4.4, y: 14.7), controlPoint2: CGPoint(x: 5, y: 14.4))
        path.addLine(to: CGPoint(x: 27.5, y: 14.4))
        path.close()
        path.move(to: CGPoint(x: 27.5, y: 4.8))
        path.addCurve(to: CGPoint(x: 29, y: 5.4), controlPoint1: CGPoint(x: 28, y: 4.8), controlPoint2: CGPoint(x: 28.6, y: 5))
        path.addCurve(to: CGPoint(x: 29.6, y: 6.9), controlPoint1: CGPoint(x: 29.3, y: 5.8), controlPoint2: CGPoint(x: 29.6, y: 6.3))
        path.addCurve(to: CGPoint(x: 29, y: 8.3), controlPoint1: CGPoint(x: 29.6, y: 7.4), controlPoint2: CGPoint(x: 29.3, y: 7.9))
        path.addCurve(to: CGPoint(x: 27.5, y: 8.9), controlPoint1: CGPoint(x: 28.6, y: 8.7), controlPoint2: CGPoint(x: 28, y: 8.9))
        path.addLine(to: CGPoint(x: 5.5, y: 8.9))
        path.addCurve(to: CGPoint(x: 4, y: 8.3), controlPoint1: CGPoint(x: 5, y: 8.9), controlPoint2: CGPoint(x: 4.4, y: 8.7))
        path.addCurve(to: CGPoint(x: 3.4, y: 6.9), controlPoint1: CGPoint(x: 3.7, y: 7.9), controlPoint2: CGPoint(x: 3.4, y: 7.4))
        path.addCurve(to: CGPoint(x: 4, y: 5.4), controlPoint1: CGPoint(x: 3.4, y: 6.3), controlPoint2: CGPoint(x: 3.7, y: 5.8))
        path.addCurve(to: CGPoint(x: 5.5, y: 4.8), controlPoint1: CGPoint(x: 4.4, y: 5), controlPoint2: CGPoint(x: 5, y: 4.8))
        path.addLine(to: CGPoint(x: 27.5, y: 4.8))
        path.close()
        return path
    }
    
    
    
    var scanRecipePath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 24.1, y: 31.2))
        path.addLine(to: CGPoint(x: 24.1, y: 28.3))
        path.addLine(to: CGPoint(x: 28.3, y: 28.3))
        path.addLine(to: CGPoint(x: 28.3, y: 24.1))
        path.addLine(to: CGPoint(x: 31.2, y: 24.1))
        path.addLine(to: CGPoint(x: 31.2, y: 29))
        path.addCurve(to: CGPoint(x: 30.5, y: 30.5), controlPoint1: CGPoint(x: 31.2, y: 29.6), controlPoint2: CGPoint(x: 30.9, y: 30))
        path.addCurve(to: CGPoint(x: 29, y: 31.2), controlPoint1: CGPoint(x: 30, y: 30.9), controlPoint2: CGPoint(x: 29.5, y: 31.2))
        path.addLine(to: CGPoint(x: 24.1, y: 31.2))
        path.close()
        path.move(to: CGPoint(x: 9.9, y: 31.2))
        path.addLine(to: CGPoint(x: 5, y: 31.2))
        path.addCurve(to: CGPoint(x: 3.5, y: 30.5), controlPoint1: CGPoint(x: 4.4, y: 31.2), controlPoint2: CGPoint(x: 4, y: 30.9))
        path.addCurve(to: CGPoint(x: 2.8, y: 29), controlPoint1: CGPoint(x: 3.1, y: 30), controlPoint2: CGPoint(x: 2.8, y: 29.5))
        path.addLine(to: CGPoint(x: 2.8, y: 24.1))
        path.addLine(to: CGPoint(x: 5.7, y: 24.1))
        path.addLine(to: CGPoint(x: 5.7, y: 28.3))
        path.addLine(to: CGPoint(x: 9.9, y: 28.3))
        path.addLine(to: CGPoint(x: 9.9, y: 31.2))
        path.close()
        path.move(to: CGPoint(x: 24.1, y: 2.8))
        path.addLine(to: CGPoint(x: 29, y: 2.8))
        path.addCurve(to: CGPoint(x: 30.5, y: 3.5), controlPoint1: CGPoint(x: 29.6, y: 2.8), controlPoint2: CGPoint(x: 30, y: 3.1))
        path.addCurve(to: CGPoint(x: 31.2, y: 5), controlPoint1: CGPoint(x: 30.9, y: 4), controlPoint2: CGPoint(x: 31.2, y: 4.4))
        path.addLine(to: CGPoint(x: 31.2, y: 9.9))
        path.addLine(to: CGPoint(x: 28.3, y: 9.9))
        path.addLine(to: CGPoint(x: 28.3, y: 5.7))
        path.addLine(to: CGPoint(x: 24.1, y: 5.7))
        path.addLine(to: CGPoint(x: 24.1, y: 2.8))
        path.close()
        path.move(to: CGPoint(x: 9.9, y: 2.8))
        path.addLine(to: CGPoint(x: 9.9, y: 5.7))
        path.addLine(to: CGPoint(x: 5.7, y: 5.7))
        path.addLine(to: CGPoint(x: 5.7, y: 9.9))
        path.addLine(to: CGPoint(x: 2.8, y: 9.9))
        path.addLine(to: CGPoint(x: 2.8, y: 5))
        path.addCurve(to: CGPoint(x: 3.5, y: 3.5), controlPoint1: CGPoint(x: 2.8, y: 4.4), controlPoint2: CGPoint(x: 3.1, y: 4))
        path.addCurve(to: CGPoint(x: 5, y: 2.8), controlPoint1: CGPoint(x: 4, y: 3.1), controlPoint2: CGPoint(x: 4.4, y: 2.8))
        path.addLine(to: CGPoint(x: 9.9, y: 2.8))
        path.close()
        path.move(to: CGPoint(x: 26.9, y: 15.6))
        path.addLine(to: CGPoint(x: 7.1, y: 15.6))
        path.addLine(to: CGPoint(x: 7.1, y: 18.4))
        path.addLine(to: CGPoint(x: 26.9, y: 18.4))
        path.addLine(to: CGPoint(x: 26.9, y: 15.6))
        path.close()
        return path
    }
    
    var pathee: UIBezierPath {
        let path = UIBezierPath()
        path.fill(with: .color, alpha: 1)
        path.move(to: CGPoint(x: 25, y: 12.5))
        path.addCurve(to: CGPoint(x: 13, y: 24.5), controlPoint1: CGPoint(x: 25, y: 19.1), controlPoint2: CGPoint(x: 19.6, y: 24.5))
        path.addCurve(to: CGPoint(x: 1, y: 12.5), controlPoint1: CGPoint(x: 6.4, y: 24.5), controlPoint2: CGPoint(x: 1, y: 19.1))
        path.addCurve(to: CGPoint(x: 13, y: 0.5), controlPoint1: CGPoint(x: 1, y: 5.9), controlPoint2: CGPoint(x: 6.4, y: 0.5))
        path.addCurve(to: CGPoint(x: 25, y: 12.5), controlPoint1: CGPoint(x: 19.6, y: 0.5), controlPoint2: CGPoint(x: 25, y: 5.9))
        path.close()
        path.lineWidth = 1.0
        return path
    }
}
