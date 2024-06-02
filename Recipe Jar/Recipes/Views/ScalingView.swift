import SwiftUI
struct ScalingView: View {

    @Binding  var scale: Double 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack {
                Text("Scale: \(scale == 1 ? "Default" : "x\(scale)")")
                    .font(CustomFont.medium.font(size: 14))
                    .padding(.top,12)
                Spacer()
            }
            Slider(value: $scale, in: 0.5...10, step: 0.5)
                .tint(CustomColor.purple)
                .padding(.bottom,12)
        }
        .foregroundColor(Color(uiColor: .navy))
        .padding(.horizontal,20)
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}
