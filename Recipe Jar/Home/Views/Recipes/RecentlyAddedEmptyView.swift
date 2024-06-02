import SwiftUI
struct RecentlyAddedEmptyView: View {
    let horizontalPadding: CGFloat
    let showFAQ: () -> Void
    var body: some View {
        Image("recently_added_placeholder")
            .resizable()
            .aspectRatio(2.2, contentMode: .fit)
            .overlay(alignment: .leading){
                VStack(alignment: .leading, spacing: 0) {
                    Text("Get started with\ncreating your own\nrecipe hub!")
                        .font(CustomFont.bold.font(.poppins, size: 17))
                        .lineSpacing(5)
                    Spacer()
                    ButtonViewV3(buttonTitle: "Show Me How", horizontalInnerPadding: 20, verticalInnerPadding: 6, cornerRadius: 31,linearGradient: LinearGradient(gradient: Gradient(colors: [Color(hex: "EDC432"), Color(hex: "FFA927")]), startPoint: .leading, endPoint: .trailing), titleFont: CustomFont.medium.font(.poppins, size: 15), function: showFAQ)
                }
                .padding([.vertical,.leading],16)
            }
            .padding(.horizontal,horizontalPadding)
    }
}

