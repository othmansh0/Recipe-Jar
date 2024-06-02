//
//  PopoverBackgroundView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 08/05/2024.
//

import UIKit
import SwiftUI
class PopoverContentController<ContentView: View>: UIViewController {
    private var hostingController: UIHostingController<ContentView>?

    init(rootView: ContentView) {
        super.init(nibName: nil, bundle: nil)
        hostingController = UIHostingController(rootView: rootView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let hostingController = hostingController else { return }

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        // Adjust the size of the popover after the layout
        DispatchQueue.main.async {
            self.adjustPopoverSize()
        }
    }

    private func adjustPopoverSize() {
        guard let hostingView = hostingController?.view else { return }

        // Use UIView.layoutFittingCompressedSize to allow the view to compress to its content size
        let targetSize = UIView.layoutFittingCompressedSize
        let size = hostingView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel, // Allow width to adapt
            verticalFittingPriority: .fittingSizeLevel) // Allow height to adapt too

        // Update the preferredContentSize with the calculated adaptive size
        self.preferredContentSize = size
    }
}


class PopoverBackgroundView: UIPopoverBackgroundView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.backgroundColor = .red
        
        self.layer.backgroundColor = UIColor.black.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override static func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    override static func arrowHeight() -> CGFloat {
        return 0
    }

    override var arrowDirection: UIPopoverArrowDirection {
        get { return UIPopoverArrowDirection.down }
        set { setNeedsLayout() }
    }

    override var arrowOffset: CGFloat {
        get { return 0 }
        set { setNeedsLayout() }
    }
}

