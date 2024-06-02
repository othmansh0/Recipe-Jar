//
//  FAQVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 15/04/2024.
//

import UIKit
class FAQVC: BaseVC {
    var expandQuestion1: Bool!
    init(expandQuestion1: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.expandQuestion1 = expandQuestion1
    }
  
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .chevronButton, buttonImageName: nil,overridenDetailTitle: "")
        hostSwiftUIView {
            FAQScreen(expandQuestion1: expandQuestion1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(shouldShow: false)
    }
}
