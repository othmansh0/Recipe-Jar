//
//  FAQScreen.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 15/04/2024.
//

import SwiftUI
import MessageUI
struct FAQScreen: View {
    var expandQuestion1: Bool
    
    private let horizontalPadding = 15.0
    
    @State private var showMailView = false
    @State private var showAlert = false
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        BaseScreen(isLoading: [.constant(false)],isTabBarHidden: true, error: .constant(nil)) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Common Questions 🤔")
                                .font(CustomFont.medium.font(.poppins, size: 20))
                            
                            ForEach(Array(zip(FAQModel.questions.indices, FAQModel.questions)), id: \.0) { (index,item) in
                                FAQItemView(question: item, forceExpandQ: index == 0 && expandQuestion1 ,tappedItem: { _ in })
                                    .padding(.bottom,index ==  FAQModel.questions.count - 1 ? 15 : 0)
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }
                    
                    SettingsDetailCellView(title: "Contact Us",
                                           image: Image(systemName: "phone"),
                                           imageColor: Color(hex: "19C416"),
                                           addBorder: true,
                                           action: { presentMailView() })
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, 32)
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $showMailView) {
                MailView(result: self.$result, recipients: ["recipejarjo@gmail.com"], subject: "Feedback", body: SettingsVM().defaultEmailBody())
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Cannot Send Email"),
                    message: Text("Your device is not configured to send mail. Please set up a mail account in order to send emails."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
    }

    func presentMailView() {
        if MFMailComposeViewController.canSendMail() { self.showMailView = true }
        else { self.showAlert = true }
    }
}
