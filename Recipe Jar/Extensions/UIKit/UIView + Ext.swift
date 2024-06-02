import UIKit
extension UIView {

  // MARK: - Single view animation

  ///
  /// Move the view from the center of the screen to the top with bounce animation.
  ///
  func moveFromCenterToTopWithBounce(withDuration duration: TimeInterval = 0,
                                     delay: TimeInterval = 0,
                                     completion: ((Bool) -> Void)? = nil) {
    let orginalFrame = frame
    var newFrame = orginalFrame
    newFrame.origin.y = ((superview?.bounds.height ?? 0) / 2) - (frame.height / 2)
    frame = newFrame
    alpha = 1
    UIView.animate(withDuration: duration,
                   delay: delay,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0.6,
                   options: [AnimationOptions.curveEaseOut],
                   animations: {

                    self.frame = orginalFrame
    }, completion: completion)
  }

  ///
  /// Move the view from the given `direction` to the current postion.
  /// - Parameter direction: The direction that the view will come from,
  ///                        expected values (left, right, top or bottom).
  /// - Parameter offset : This value will effect the y and x axis, so if you put it 50 and the
  ///                      direction type as left, the view will come from (frame.origin.x + 50)
  ///                      to the orginal x. The default value is `30`.
  /// - Parameter hideAtEnd : If this value is true the alpha of the view will be 0 at the end.
  ///                         The default is `false`.
  ///
  func animateFrom(direction: AnimationDirection,
                   duration: TimeInterval,
                   delay: TimeInterval = 0,
                   hideAtEnd: Bool = false,
                   offset: CGFloat = 30,
                   completion: ((Bool) -> Void)? = nil) {
    let orginalFrame = frame
    var newFrame = orginalFrame
    switch direction {
    case .top:
      newFrame.origin.y -= offset
    case .bottom:
      newFrame.origin.y += offset
    case .left:
      newFrame.origin.x -= offset
    case .right:
      newFrame.origin.x += offset
    }
    frame = newFrame
    UIView.animate(withDuration: duration,
                   delay: delay,
                   options: [AnimationOptions.curveEaseOut],
                   animations: {

                    self.frame = orginalFrame
                    self.alpha = hideAtEnd ? 0 : 1

    }, completion: completion)
  }

  ///
  /// Move the view from the current postion to the given `direction`.
  /// - Parameter direction: The direction that the view will move to,
  ///                        expected values (left, right, top or bottom).
  /// - Parameter offset : This value will effect the y and x axis, so if you put it 50 and the direction
  ///                      type as left, the view will move from the current x to (frame.origin.x + 50).
  ///                      The default value is `30`.
  /// - Parameter hideAtEnd : If this value is true the alpha of the view will be 0 at the end.
  ///                         The default is `false`.
  ///
  func animateTo(direction: AnimationDirection,
                 duration: TimeInterval,
                 delay: TimeInterval = 0,
                 hideAtEnd: Bool = false,
                 offset: CGFloat = 30,
                 completion: ((Bool) -> Void)? = nil) {
    let orginalFrame = frame
    var newFrame = frame
    switch direction {
    case .top:
      newFrame.origin.y -= offset
    case .bottom:
      newFrame.origin.y += offset
    case .left:
      newFrame.origin.x -= offset
    case .right:
      newFrame.origin.x += offset
    }
    UIView.animate(withDuration: duration,
                   delay: delay,
                   options: [AnimationOptions.curveEaseOut],
                   animations: {

                    self.frame = newFrame
                    self.alpha = hideAtEnd ? 0 : 1
    }, completion: { done in
      self.alpha = hideAtEnd ? 0 : 1
      self.frame = orginalFrame
      completion?(done)
    })
  }

  ///
  /// Scale the view with the givin `x` and `y`.
  ///
  func animate(scaleX x: CGFloat, y: CGFloat, duration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: duration,
                   animations: {
      self.transform = CGAffineTransform(scaleX: x, y: y)
    }, completion: completion)
  }

  ///
  /// Animate the alpha of the view with `duration`.
  /// - Parameter duration: Defualt value for duration is `0.5`.
  ///
  func animate(alpha: CGFloat, with duration: Double = 0.5) {
    UIView.animate(withDuration: duration) {
      self.alpha = alpha
    }
  }

  private static let kRotationAnimationKey = "rotationanimationkey"

  func rotate(duration: Double = 1) {
    if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
      let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

      rotationAnimation.fromValue = 0.0
      rotationAnimation.toValue = Float.pi * 2.0
      rotationAnimation.duration = duration
      rotationAnimation.repeatCount = Float.infinity

      layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
    }
  }

  func stopRotating() {
    if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
      layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
    }
  }

  ///
  /// Hide all subviews inside the view
  /// - Parameter except: The views that you don't want to hide.
  /// - Parameter animated: Defualt value for animated is false.
  ///
  func hideViews(except: UIView..., animated: Bool = false) {
    let subviews = self.subviews.filter { !except.contains($0) }
    if animated {
      subviews.forEach { $0.animate(alpha: 0) }
    } else {
      subviews.forEach { $0.alpha = 0 }
    }
  }

  ///
  /// Show all subviews inside the view
  /// - Parameter animated: Defualt value for animated is false.
  ///
  func showViews(animated: Bool = false) {
    if animated {
      subviews.forEach { $0.alpha = 1 }
    } else {
      subviews.forEach { $0.animate(alpha: 1) }
    }
  }

  func animateBorder(color: UIColor, with duration: Double) {
    let borderColor: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
    borderColor.toValue = color.cgColor
    borderColor.duration = duration
    borderColor.fillMode = .both
    borderColor.isRemovedOnCompletion = false
    layer.add(borderColor, forKey: "borderColor")
  }

  // MARK: - Multiple view animation

  func animateSubviewsFromBottom() {
    hideViews()
    UIView.animate(views: subviews, from: .bottom, duration: 0.3, delay: 0.2)
  }

  ///
  /// Move the views from the given `direction` to the current postion.
  /// - Parameter direction: The direction that the views will come from,
  ///                        expected values (left, right, top or bottom).
  /// - Parameter initialDelay: The delay before any of the views start animating.
  /// - Parameter delay: The delay betwen each view multiplied by the (offset + 0.1), so first view
  ///                   will have (delay*0.1) second view will have (delay*1.1) third will have
  ///                   (delay*2.1) etc..
  /// - Parameter offset : This value will effect the y and x axis, so if you put it 50 and the
  ///                      direction type as left, the view will come from (frame.origin.x + 50)
  ///                      to the orginal x. The default value is `30`.
  /// - Parameter hideAtEnd : If this value is true the alpha of the view will be 0 at the end.
  ///                         The default is `false`.
  ///
  static func animate(views: [UIView],
                      from direction: AnimationDirection,
                      duration: TimeInterval,
                      initialDelay: TimeInterval = 0,
                      delay: TimeInterval = 0,
                      hideAtEnd: Bool = false,
                      offset: CGFloat = 30) {
    views.enumerated().forEach {
      $0.element.animateFrom(direction: direction,
                             duration: duration,
                             delay: initialDelay + (delay * (Double($0.offset) + 0.1)),
                             hideAtEnd: hideAtEnd,
                             offset: offset)
    }
  }

  ///
  /// Move the view from the current postion to the given `direction`.
  /// - Parameter direction: The direction that the view will move to,
  ///                        expected values (left, right, top or bottom).
  /// - Parameter initialDelay: The delay before any of the views start animating.
  /// - Parameter delay: The delay betwen each view multiplied by the (offset + 0.1), so first view
  ///                   will have (delay*0.1) second view will have (delay*1.1) third will have
  ///                   (delay*2.1) etc..
  /// - Parameter offset : This value will effect the y and x axis, so if you put it 50 and the direction
  ///                      type as left, the view will move from the current x to (frame.origin.x + 50).
  ///                      The default value is `30`.
  /// - Parameter hideAtEnd : If this value is true the alpha of the view will be 0 at the end.
  ///                         The default is `false`.
  ///
  static func animate(views: [UIView],
                      to direction: AnimationDirection,
                      duration: TimeInterval,
                      initialDelay: TimeInterval = 0,
                      delay: TimeInterval = 0,
                      hideAtEnd: Bool = false,
                      offset: CGFloat = 30) {
    views.enumerated().forEach {
      $0.element.animateTo(direction: direction,
                           duration: duration,
                           delay: initialDelay + (delay * (Double($0.offset) + 0.1)),
                           hideAtEnd: hideAtEnd,
                           offset: offset)
    }
  }
}

enum AnimationDirection {
  case top
  case bottom
  case right
  case left
}
