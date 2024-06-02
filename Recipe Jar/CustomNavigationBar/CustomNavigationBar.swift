//
//  CustomNavigationBar.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/12/2023.
//

import UIKit
class CustomNavigationBar: UIView {
   
    var overridenDetailTitle: String?
    var buttonTitle: String?
    var backButton: UIButton?
    var leftButton: UIButton!
    var rightButton: UIButton!
    var buttonImageName: String?
    var isYouTubeDisabled: Bool!
    var menuActions: [UIAction]?
    var circularImageView: CircularImageView!
    var titleLabel = TitleLabel(text: "hey", textAlignment: .center, fontSize: 24, fontWeight: .bold, textColor: UIColor(red: 0.5, green: 0.32, blue: 0.51, alpha: 1))
    
    let homeStackView = UIStackView()
    let titleWithTwoButtonsStack = UIStackView()
    
    
    let stepsScreenStack = UIStackView()
    var firstActionItem: CircularImageView!
    var secondActionItem: CircularImageView!
    var thirdActionItem: CircularImageView!
    var fourthActionItem: CircularImageView!
    var firstActionItemFrame: CGRect!
    
    weak var delegate: CustomNavigationBarDelegate?
    
    private var navigationStyle: CustomNavigationStyle = .root
    
    
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title: title)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
enum CustomNavigationStyle {
    case root
    case chevronButton
    case titleOnly
    case settings
    case detail
    case titleWithTwoButtons
    case titleWithOneButton
    case backButton
    case crossButton
    case stepsItems
}

protocol CustomNavigationBarDelegate: AnyObject {
    func customNavigationBarDidTapBackButton()
    func leftButtonAction()
    func rightButtonAction()
    
    func firstItemAction()
    func secondItemAction()
    func thirdItemAction()
    func fourthItemAction()
}




//MARK: Setup functions
extension CustomNavigationBar {
    
    func updateNavigationStyle(backgroundColor: UIColor? = nil) {
        switch navigationStyle {
        case .root:
            backButton?.removeFromSuperview()
            configureHomeStack()
            
        case .chevronButton:
            configureTitleWithButtonsStack(overridenDetailTitle: overridenDetailTitle,numberOfButtons: 1)

            
        case .titleOnly:
            configureTitleWithButtonsStack(numberOfButtons: 0)
        case .settings:
            configureTitleWithButtonsStack(numberOfButtons: 0,backgroundColor: backgroundColor)
        case .detail:
            break
        case .titleWithOneButton:
            configureTitleWithButtonsStack(numberOfButtons: 1,actions: menuActions)
        case .titleWithTwoButtons:
            backButton?.removeFromSuperview()
            homeStackView.removeFromSuperview()
            configureTitleWithButtonsStack(numberOfButtons: 2)
            
        case .backButton:
            homeStackView.removeFromSuperview()
            titleWithTwoButtonsStack.removeFromSuperview()
            configureBackButtonOnly(backButtonStyle: .arrow)
            
        case .crossButton:
            homeStackView.removeFromSuperview()
            titleWithTwoButtonsStack.removeFromSuperview()
            backButton?.removeFromSuperview()
            configureBackButtonOnly(backButtonStyle: .cross)
                        
        case .stepsItems:
            homeStackView.removeFromSuperview()
            titleWithTwoButtonsStack.removeFromSuperview()
            circularImageView?.removeFromSuperview()
            configureStepsStack()
        }
    }
    
    private func configureBackButtonOnly(backButtonStyle: BackButtonStyle,parentStackView: UIStackView? = nil) {
        circularImageView = CircularImageView(width: 47,
                                              height: 47,
                                              image: backButtonStyle.buttonImage,
                                              imageWidth:backButtonStyle.imageSize.width,
                                              imageHeight:backButtonStyle.imageSize.height,
                                              imageColor: .secondary,
                                              onTap: backButtonTapped)
        
        if let parentStackView = parentStackView {
            
            parentStackView.addArrangedSubview(circularImageView)
            NSLayoutConstraint.activate([
                circularImageView.heightAnchor.constraint(equalToConstant: 47),
                circularImageView.widthAnchor.constraint(equalToConstant: 47)
            ])
        }
        else {
            addSubview(circularImageView)
            
            NSLayoutConstraint.activate([
                circularImageView.topAnchor.constraint(equalTo: topAnchor,constant: UIScreen.screenHeight*0.07042254),
                circularImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                circularImageView.heightAnchor.constraint(equalToConstant: 47),
                circularImageView.widthAnchor.constraint(equalToConstant: 47)
            ])
        }
    }
    
    func configureStackConstraints(_ stack: UIStackView,topSpaceFromStatusBar: CGFloat = UIScreen.screenHeight * 0.0528169,leading: CGFloat,trailing: CGFloat) {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor,constant: topSpaceFromStatusBar),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailing),
            stack.heightAnchor.constraint(equalTo: heightAnchor,constant: -topSpaceFromStatusBar)
        ])        
    }
    
    func setNavigationStyle(to navigationStyle: CustomNavigationStyle,buttonImageName: String?,isYouTubeDisabled: Bool = false,backgroundColor: UIColor?,menuActions: [UIAction]? = nil,overridenDetailTitle: String?,buttonTitle: String?) {
        self.navigationStyle = navigationStyle
        self.buttonImageName = buttonImageName
        self.backgroundColor = backgroundColor
        self.isYouTubeDisabled = isYouTubeDisabled
        self.menuActions = menuActions
        self.overridenDetailTitle = overridenDetailTitle
        self.buttonTitle = buttonTitle
        updateNavigationStyle()
    }
    
    private func setTitle(title: String? = nil) { titleLabel.text = title }

    @objc private func backButtonTapped() {
        delegate?.customNavigationBarDidTapBackButton()
    }
    
    func adjustStepsItemsEnablity(enability: Bool) {
        var buttons = [firstActionItem,secondActionItem,thirdActionItem,fourthActionItem]
        if enability {
            for button in buttons { button?.enable() }
        }
        else {
            for button in buttons { button?.disable() }
        }
    }
}



//MARK: Title With Buttons Stack
extension CustomNavigationBar {
    private func configureTitleWithButtonsStack(overridenDetailTitle: String? = nil,numberOfButtons: Int,actions: [UIAction]? = nil,backgroundColor: UIColor? = nil) {
            
            if numberOfButtons != 0 {
                if numberOfButtons == 2 {
                    leftButton = CustomButton(buttonColor: .navy, buttonWidth: 25,buttonHeight: 25 ,buttonImage: UIImage(named: "ellipsis.circle"))
                    leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
                }
                rightButton = CustomButton(buttonColor: .navy, buttonWidth: 25,buttonHeight: 25,buttonImage: UIImage(named: buttonImageName ?? ""))
                rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
                if let actions = actions {
                    let menu = UIMenu(title: "", children: actions)
                    showMenuForButton(rightButton, menu: menu)
                }
                configureBackButtonWithNoBG(parentStackView: titleWithTwoButtonsStack)
            }
            if let overridenDetailTitle = overridenDetailTitle {
                titleLabel.text = overridenDetailTitle
            }
            titleWithTwoButtonsStack.addArrangedSubview(titleLabel)
            titleWithTwoButtonsStack.addArrangedSubview(UIView())
            if numberOfButtons == 2 { titleWithTwoButtonsStack.addArrangedSubview(leftButton) }
            if numberOfButtons != 0 { titleWithTwoButtonsStack.addArrangedSubview(rightButton) }
            
            titleWithTwoButtonsStack.axis = .horizontal
            titleWithTwoButtonsStack.distribution = .fill
            titleWithTwoButtonsStack.alignment = .center
            titleWithTwoButtonsStack.spacing = 10
            if let backgroundColor = backgroundColor { titleWithTwoButtonsStack.backgroundColor = backgroundColor }
            titleWithTwoButtonsStack.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleWithTwoButtonsStack)
            
            configureStackConstraints(titleWithTwoButtonsStack,leading: 24,trailing: 24)
        }
    
    private func configureBackButtonWithNoBG(parentStackView: UIStackView) {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .heavy)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)?.withTintColor(UIColor(red: 0.5, green: 0.32, blue: 0.51, alpha: 1), renderingMode: .alwaysOriginal)
        backButton = CustomButton(buttonColor: UIColor(red: 0.5, green: 0.32, blue: 0.51, alpha: 1), buttonWidth: 15.64,buttonHeight: 26.01,buttonImage: image)
        backButton!.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        guard  let backButton = backButton else { return }
        parentStackView.addArrangedSubview(backButton)
    }
    
}


//MARK: Home Stack
extension CustomNavigationBar {
    private func configureHomeStack() {
        leftButton = CustomButton(buttonColor: .primary, buttonWidth: 24, buttonHeight: 24, buttonImage: UIImage(named: "burgermenu"))
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        rightButton = CustomButton(buttonColor: .primary, buttonWidth: 24, buttonHeight: 24, buttonImage: UIImage(named: "scan"))
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        homeStackView.addArrangedSubview(leftButton)
        homeStackView.addArrangedSubview(titleLabel)
        homeStackView.addArrangedSubview(rightButton)
        
        homeStackView.axis = .horizontal
        homeStackView.alignment = .center
        homeStackView.distribution = .equalCentering
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(homeStackView)
        
        configureStackConstraints(homeStackView,leading: 24,trailing: 24)
    }
    
    
    @objc private func leftButtonTapped() {
        delegate?.leftButtonAction()
    }
    
    @objc private func rightButtonTapped() {
        delegate?.rightButtonAction()
    }
}


//MARK: Steps Stack
extension CustomNavigationBar {
    private func configureStepsStack() {
        
        stepsScreenStack.axis = .horizontal
        stepsScreenStack.distribution = .fill
        stepsScreenStack.alignment = .center
        stepsScreenStack.spacing = 10
        addSubview(stepsScreenStack)
        
        configureBackButtonOnly(backButtonStyle: .cross, parentStackView: stepsScreenStack)
        stepsScreenStack.addArrangedSubview(UIView())
        
        let actions = [stepsFirstItemTapped,stepsSecondItemTapped,stepsThirdItemTapped,stepsFourthItemTapped]
        var buttons = [firstActionItem,secondActionItem,thirdActionItem,fourthActionItem]
        
        
        firstActionItem = CircularImageView(width: 34,
                                            height: 34,
                                            image: StepsButton.ingredients.buttonImage,
                                            imageWidth: StepsButton.ingredients.imageSize.width,
                                            imageHeight: StepsButton.ingredients.imageSize.height,
                                            imageColor: .primary,
                                            onTap: stepsFirstItemTapped)
        
        secondActionItem = CircularImageView(width: 34,
                                             height: 34,
                                             image: StepsButton.youtube.buttonImage,
                                             imageWidth: StepsButton.youtube.imageSize.width,
                                             imageHeight: StepsButton.youtube.imageSize.height,
                                             imageColor: isYouTubeDisabled ? UIColor(hex: "858585") : .primary,
                                             fillColor: isYouTubeDisabled ?  UIColor(hex: "E8E8E8")! : .white,
                                             onTap: stepsSecondItemTapped)
        
        
        thirdActionItem = CircularImageView(width: 34,
                                            height: 34,
                                            image: StepsButton.textToSpeech.buttonImage,
                                            imageWidth: StepsButton.textToSpeech.imageSize.width,
                                            imageHeight: StepsButton.textToSpeech.imageSize.height,
                                            imageColor: .primary,
                                            onTap: stepsThirdItemTapped)
        
        
        fourthActionItem = CircularImageView(width: 34,
                                             height: 34,
                                             image: StepsButton.voiceCommands.buttonImage,
                                             imageWidth: StepsButton.voiceCommands.imageSize.width,
                                             imageHeight: StepsButton.voiceCommands.imageSize.height,
                                             imageColor: .primary,
                                             onTap: stepsFourthItemTapped)
        
        
        
        
        NSLayoutConstraint.activate([
            firstActionItem.heightAnchor.constraint(equalToConstant: 34),
            firstActionItem.widthAnchor.constraint(equalToConstant: 34),
            
            secondActionItem.heightAnchor.constraint(equalToConstant: 34),
            secondActionItem.widthAnchor.constraint(equalToConstant: 34),
            
            thirdActionItem.heightAnchor.constraint(equalToConstant: 34),
            thirdActionItem.widthAnchor.constraint(equalToConstant: 34),
            
            
            fourthActionItem.heightAnchor.constraint(equalToConstant: 34),
            fourthActionItem.widthAnchor.constraint(equalToConstant: 34)
            
        ])
        
        
        stepsScreenStack.addArrangedSubview(firstActionItem)
        stepsScreenStack.addArrangedSubview(secondActionItem)
        stepsScreenStack.addArrangedSubview(thirdActionItem)
        stepsScreenStack.addArrangedSubview(fourthActionItem)
        
        stepsScreenStack.translatesAutoresizingMaskIntoConstraints = false
        
        configureStackConstraints(stepsScreenStack,leading: 32,trailing: 32)
    }
    
    
    @objc private func stepsFirstItemTapped() {
        delegate?.firstItemAction()
    }
    
    
    @objc private func stepsSecondItemTapped() {
        delegate?.secondItemAction()
    }
    
    @objc private func stepsThirdItemTapped() {
        delegate?.thirdItemAction()
    }
    
    @objc private func stepsFourthItemTapped() {
        delegate?.fourthItemAction()
    }
}

//MARK: Menu
extension CustomNavigationBar {
    private func showMenuForButton(_ button: UIButton, menu: UIMenu) {
       button.showsMenuAsPrimaryAction = true
       button.menu = menu
   }
}
