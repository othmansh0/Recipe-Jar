import SwiftUI
struct SettingItemView: View {
    var body: some View {
        ZStack{
            HStack{
                Text("Privacy Policy")
                    .font(CustomFont.medium.font(size: 15))
                    .foregroundColor(Color(uiColor: .navy))
                    .padding(.leading,10)
                Spacer()
                ZStack{
                    Circle()
                        .fill(Color(red: 238.0/255, green: 239.0/255, blue: 243.0/255))
                        .frame(width: 24,height:24 ,alignment: .trailing)
                        .padding(.vertical,19)
                        .padding(.horizontal,18)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(CustomColor.purple)
                }
            }
            
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(CustomColor.formBorderColor, lineWidth: 1)
            )
        }
    }
}

struct SettingItemView_Previews: PreviewProvider {
    static var previews: some View {
        SettingItemView()
    }
}
