import SwiftUI
import MessageUI
import UserNotifications

struct SettingsScreen: View {
    
    @ObservedObject var vm: SettingsVM
    @ObservedObject var authVM: AuthViewModel
    let notificationsTapped: () -> ()


    
    @State private var showTerms = false
    @State private var showMailView = false
    @State private var showAlert = false
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    
    private let borderColor = Color(hex:"#7F5283",opacity: 0.08)
    private let textColor = Color(hex:"#232946",opacity: 0.08)

    var body: some View {
        BaseScreen(isLoading: [$vm.isLoading], error: $vm.error) {
            VStack(alignment: .leading,spacing: 0) {
                SettingsSection(title: "General", topPadding: 0) {
                    SettingsToggleCellView(title: "Notifications",
                                           image: Image("settings_bell"),
                                           isOn: $vm.isNotificationsEnabled, action: notificationsTapped)
                    Rectangle()
                        .fill(borderColor)
                        .frame(height: 0.5)
                }
                
                SettingsSection(title: "Support") {
                    SettingsDetailCellView(title: "Contact Us",
                                           image: Image(systemName: "phone"),
                                           imageColor: Color(hex: "19C416"),
                                           addBorder: true,
                                           action: { presentMailView() })
                }
                
                SettingsSection(title: "Terms of Use") {
                    SettingsDetailCellView(title: "Terms and Conditions",
                                           image: Image("settings_terms"),
                                           addBorder: true,
                                           action: { showTerms = true })
                }
                
                SettingsSection(title: "") {
                    SettingsDetailCellView(title: "Erase Data",
                                           textColor: Color(hex: "FF5858"),
                                           addBorder: true,
                                           isArrowHidden: true,
                                           action: {Task {await authVM.deleteUser()}})
                }

                Spacer()
            }
            .background(Color(hex:"FBFBFB"))
            .fullScreenCover(isPresented: $showTerms) {
                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                    SafariView(url: url)
                        .ignoresSafeArea(.all)
                }
            }
            
            .sheet(isPresented: $showMailView) {
                MailView(result: self.$result, recipients: ["recipejarjo@gmail.com"], subject: "Feedback", body: vm.defaultEmailBody())
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
