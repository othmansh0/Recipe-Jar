import SwiftUI

struct ButtonView: View {

    var width: CGFloat?
    var height: CGFloat?
    var cornerRadius: CGFloat?
    var buttonColor: Color?
    var titleColor: Color?
    var titleSize: CGFloat?
    var function: () async ->  Void
    
    @State var buttonTitle:String = ""
    
    var body: some View {
        Button(action: {
            Task{ await function() }
        }) {
            Text(buttonTitle)
                .foregroundColor(titleColor ?? .white)  
                .font(Font.custom("FiraSans-Medium", size: titleSize ?? 20))
                .frame(maxWidth: width ?? .infinity,maxHeight: height ?? .infinity)
                .foregroundColor(Color.black)
                .background(buttonColor ?? CustomColor.yellow)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 9))
        }
    }
}





// TODO:  Should replace button view later on
struct ButtonViewV2: View {
    
    var buttonTitle:String = ""
    var width: CGFloat?
    var height: CGFloat?
    var cornerRadius: CGFloat?
    var buttonColor: Color?
    var titleColor: Color? = .white
    var titleAlignment: TextAlignment? = .leading
    var titleFont: Font = Font.custom("NeoSansArabic-Bold", size: 14 )
    var iconName: String?
    var iconColor: Color?
    var sfSymbolIconName: String?
    var borderColor: Color?
    var borderWidth: CGFloat?
    var function: () async -> Void
    
    
    var body: some View {
        Button(action: {
            Task {
                await function()
            }
        }) {
            HStack {
                if let iconName = iconName{
                    Image(iconName)
                        .renderingMode(iconColor != nil ? .template : .original)
                        .foregroundColor(iconColor)
                }
                Text(buttonTitle)
                    .foregroundColor(titleColor ?? .white)
                    .font(titleFont)
                    .multilineTextAlignment(titleAlignment ?? .center)
                    .lineSpacing(5.25)
                    .foregroundColor(Color.black)
                    .isHidden(buttonTitle.isEmpty, remove: buttonTitle.isEmpty)
                if let sfSymbolIconName = sfSymbolIconName {
                    Image(systemName: sfSymbolIconName)
                        .resizable()
                        .frame(width: 12, height: 12, alignment: .trailing)
                        .foregroundColor(.white)
                        .font(titleFont)
                        .padding(.leading,4)
                }
            }
            //      .padding(.horizontal,)
            .frame(maxWidth: width ?? .infinity,maxHeight: height ?? .infinity)
            .background(buttonColor ?? Color(uiColor: .fuschia_400))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 9))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius ?? 9)
                    .stroke(borderColor ?? .clear, lineWidth: borderWidth ?? 1)
            )
        }
    }
}





//MARK: This is a better version of the button view where the height and width of the button depends on the padding of the button text instead of frame
//which fixes the issue of inconsistent padding
struct ButtonViewV3: View {
    
    var buttonTitle:String = ""
    var horizontalInnerPadding: CGFloat?
    var verticalInnerPadding: CGFloat?
    var cornerRadius: CGFloat?
    var buttonColor: Color?
    var linearGradient: LinearGradient? // New optional LinearGradient parameter
    var titleColor: Color? = .white
    var titleAlignment: TextAlignment? = .leading
    var titleFont: Font = Font.custom("NeoSansArabic-Bold", size: 14 )
    var iconName: String?
    var iconColor: Color?
    var sfSymbolIconName: String?
    var borderColor: Color?
    var borderWidth: CGFloat?
    var function: () async -> Void

    var body: some View {
        let solidGradient = LinearGradient(colors: [buttonColor ?? CustomColor.purple], startPoint: .leading, endPoint: .trailing)
        Button(action: {
            Task {
                await function()
            }
        }) {
            HStack {
                if let iconName = iconName{
                    Image(iconName)
                        .renderingMode(iconColor != nil ? .template : .original)
                        .foregroundColor(iconColor)
                }
                Text(buttonTitle)
                    .foregroundColor(titleColor ?? .white)
                    .font(titleFont)
                    .multilineTextAlignment(titleAlignment ?? .center)
                    .lineSpacing(5.25)
                    .foregroundColor(Color.black)
                    .isHidden(buttonTitle.isEmpty, remove: buttonTitle.isEmpty)
                if let sfSymbolIconName = sfSymbolIconName {
                    Image(systemName: sfSymbolIconName)
                        .resizable()
                        .frame(width: 12, height: 12, alignment: .trailing)
                        .foregroundColor(.white)
                        .font(titleFont)
                        .padding(.leading,4)
                }
            }
            .padding(.horizontal,horizontalInnerPadding)
            .padding(.vertical,verticalInnerPadding)

            .background(linearGradient ?? solidGradient)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 9))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius ?? 9)
                    .stroke(borderColor ?? .clear, lineWidth: borderWidth ?? 1)
            )
        }
    }
}


