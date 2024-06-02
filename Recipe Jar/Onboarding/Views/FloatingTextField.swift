
import SwiftUI
struct FloatingTextField: View {
    
    private var title: String
    @State var width: CGFloat
    @State var placeHolderSize: CGFloat
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>,width:CGFloat,placeHolderSize:CGFloat) {
        self.title = title
        self._text = text
        self.width = width
        self.placeHolderSize = placeHolderSize
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .font(Font.custom("FiraSans-Light", size: placeHolderSize))
            
                .foregroundColor(CustomColor.PlaceholderColor)
                .foregroundColor(Color(.placeholderText))
                .offset(x:8,y: text.isEmpty ? 4 : -12)
                .scaleEffect(text.isEmpty ? 1: 0.8, anchor: .leading)
            
            TextField("", text: $text)
                .padding(.top,23)
                .padding(.bottom,8)
                .padding(.horizontal,8)
                .frame(width: width)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(CustomColor.textFieldColor)
                )
        }
        .background(CustomColor.textFieldColor)
        .cornerRadius(9)
        .animation(.default)
    }
}
