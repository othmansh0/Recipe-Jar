
import SwiftUI
import YouTubePlayerKit
struct YouTubeModalView: View {
    @Binding var isShowing: Bool
    let videoObject: VideoURL
    @Binding var isPresentingStepsScreen: Bool
    let openYouTubeScreen: (VideoURL) -> Void
    
    var body: some View{
        //MARK: Modal view
        HStack(spacing: 0){
                   //MARK: YouTube image
                   VStack {
                       AsyncImage(url: URL(string: videoObject.image ?? "" )) { image in
                            image
                               .resizable()
                               .frame(width: 160,height: 100)
                               .cornerRadius(10)
                               .fixedSize()
                       } placeholder: {
                           Image(systemName: "photo")
                               .resizable()
                               .foregroundStyle(.grey)
                               .frame(width: 160,height: 100)
                               .cornerRadius(10)
                               .fixedSize()
                       }
                           .overlay(
                               Image(systemName: "play.circle.fill")
                           )
                           .foregroundColor(.white.opacity(0.9))
                           .font(.system(size: 50))
                           .overlay(alignment: .bottomLeading){
                               if let duration = videoObject.duration {
                                   Text(videoObject.duration ?? "")
                                       .font(Font.custom("FiraSans-Medium", size: 10))
                                       .foregroundColor(.white)
                                       .frame(width: 40, height: 15, alignment: .center)
                                       .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.black.opacity(0.6)))
                                       .padding(.bottom,12)
                                       .padding(.leading,4)
                               }
                           }
                   }
                   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                   .padding(.leading,25)
                   .padding(.bottom,20)
                   .onTapGesture {
                       openYouTubeScreen(videoObject)
                   }
            
            ZStack {
                Text(String(videoObject.title?.prefix(70) ?? ""))
                    .lineLimit(4)
                    .font(Font.custom("FiraSans-Medium", size: 16))
                    .padding(.leading,8)
                    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .topLeading)
               VStack(spacing:4) {
                   if let channelName = videoObject.channelName {
                       //MARK: Video Source
                       HStack(spacing: 0) {
                           Text(channelName)
                               .foregroundColor(Color(uiColor: UIColor(red: 35.0/255, green: 41.0/255, blue: 70.0/255, alpha: 1)))
                           Text("- RecipeJar")
                               .foregroundColor(.gray)
                               .font(.caption)
                       }
                       .frame(maxWidth: .infinity, maxHeight: 50, alignment: .bottomLeading)
                   }
                   
                   if let videoPostedDate = videoObject.videoPostedDate{
                       Text(videoPostedDate)
                           .frame(maxWidth: .infinity, maxHeight: 15, alignment: .bottomLeading)
                           .foregroundColor(.gray)
                           .font(.caption)
                   }
                }
                .padding(.leading,8)
                .font(Font.custom("FiraSans-Medium", size: 11))
            }
        }
        .frame(height: 140)
        .background(.white, in: RoundCornerShape(corners: [.topLeft,.topRight], radius: 15))
        .shadow(color: Color(UIColor(red: 26/255, green: 31/255, blue: 69/255, alpha: 0.16)), radius: 16, x: 0, y: -1)
    }
}
