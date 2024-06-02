//
//  BaseScreen.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/04/2024.
//

import SwiftUI

struct BaseScreen<Content: View>: View {
    let content: Content
    var isLoading: [Binding<Bool>]
    @Binding var isLoadingHidden: Bool
    var loadingMessage: String = ""
    var isTabBarHidden: Bool = false
    var shouldIgnoreSafeArea: Bool = true
    @Binding var error: IdentifiableError?
    @Binding var alertMessage: AlertMessage?
    let backgroundColor: Color?
    var onAlertDismiss: (() -> Void)?  // Optional closure for custom dismiss action
    
    let tabBarHeight: CGFloat = 83.0
    
    init(isLoading: [Binding<Bool>], isLoadingHidden: Binding<Bool> = .constant(false), loadingMessage: String = "",isTabBarHidden: Bool = false,shouldIgnoreSafeArea: Bool = true, alertMessage: Binding<AlertMessage?> = .constant(nil), error: Binding<IdentifiableError?>, backgroundColor: Color? = nil, onAlertDismiss: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.isLoading = isLoading
        self._isLoadingHidden = isLoadingHidden
        self.loadingMessage = loadingMessage
        self.isTabBarHidden = isTabBarHidden
        self.shouldIgnoreSafeArea = shouldIgnoreSafeArea
        self._alertMessage = alertMessage
        self._error = error
        self.backgroundColor = backgroundColor
        self.onAlertDismiss = onAlertDismiss
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Group {
                if let backgroundColor = backgroundColor {
                    backgroundColor
                } else {
                    Color(hex: "F8F8F8")
                }
            }
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                content
                Color.clear
                    .frame(height: tabBarHeight)
                    .isHidden(isTabBarHidden, remove: isTabBarHidden)
            }
            
            if isLoading.map({ $0.wrappedValue }).contains(true) && !isLoadingHidden {
                LoadingView(loadingType: .purpleLottie, loadingMessage: loadingMessage)
                    .frame(width: 250, height: 250, alignment: .center)
            }
        }
        .edgesIgnoringSafeArea(shouldIgnoreSafeArea ? .all : [])
        .handleError($error, onDismiss: onAlertDismiss)
        .alert(item: $alertMessage) { alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .default(Text("OK")))
        }
    }
}
