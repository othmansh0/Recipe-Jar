import SwiftUI
import SwiftUIIntrospect
struct StepView: View {
    let step: Step
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Step \(step.orderNumber)")
                .font(Font.custom("FiraSans-Bold", size: 24))
                .padding(.bottom, 10)
            
            ScrollView(.vertical,showsIndicators: false) {
                VStack {
                    Text(step.description)
                        .padding(.bottom,4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                scrollView.alwaysBounceVertical = false
            }
            .font(Font.custom("FiraSans-Medium", size: 18))
            .lineSpacing(5)
            .foregroundColor(Color(uiColor: UIColor(red: 35.0/255.0, green: 41.0/255.0, blue: 70.0/255.0, alpha: 1)))
        }
    }
}
