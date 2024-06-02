import SwiftUI
import YouTubePlayerKit
struct YouTubeScreen: View {
    let youTubePlayer:YouTubePlayer
    let videoObj:VideoURL
    let steps:[Step]
    let exitYouTubeScreen: () -> Void
    let stopCooking: () -> Void
    
    @State private var currentIndex = 0
    
    var body: some View {
            VStack(spacing:-10){
                YouTubePlayerView(self.youTubePlayer) { state in
                    switch state {
                    case .idle:
                        ProgressView()
                    case .ready:
                        EmptyView()
                    case .error(let error):
                        Text(verbatim: "YouTube player couldn't be loaded")
                    }
                }
                .aspectRatio(1.75, contentMode: .fill)
                Spacer()
                HStack(spacing:0){
                    //MARK: Title Section
                VStack(alignment: .leading,spacing: 8) {
                        Text(videoObj.title ?? "")
                            .lineLimit(1)
                            .font(Font.custom("FiraSans-Medium", size: 16))
                        HStack(alignment: .top){
                            VStack(alignment: .leading, spacing: 4) {
                                //MARK: Video Source
                                HStack(spacing: 0) {
                                    Text("YouTube")
                                        .foregroundColor(Color(uiColor: UIColor(red: 35.0/255, green: 41.0/255, blue: 70.0/255, alpha: 1)))
                                        .font(CustomFont.medium.font(size: 11))
                                    Text(" - RecipeJar")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                
                                if let videoPostedDate = videoObj.videoPostedDate {
                                    Text(videoPostedDate)
                                        .frame(maxWidth: .infinity, maxHeight: 15, alignment: .bottomLeading)
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                            Spacer()
                            Button{ exitYouTubeScreen() } label: { Image("ExitVideo") }
                        }
                    }
                }
                .padding(.horizontal,36)
                .padding(.top,25)
                Spacer()
                //MARK: Steps Section
                VStack(spacing:30) {
                        Divider()
                            .padding(.top,45)
                            .frame(maxWidth: .infinity,alignment: .center)
                            .padding(.horizontal,36)
                    SnapCarousel(spacing:10,trailingSpace:0, index: $currentIndex, items: steps,isEnglish:true,autoPlayDuration: nil,stopAutoPlayAfterOneCyle: false) { step in
                        StepView(step: step)
                    }
                    .clipped()
                    .padding(.horizontal,36)
                    .frame(maxWidth: .infinity,maxHeight: 300, alignment: .topLeading)
                    
                    HStack {
                        PageIndicatorView(numberOfPages: steps.count, currentIndex:currentIndex)
                    }
                }
                .padding(.bottom,70)
                Button {
                    stopCooking()
                } label: {
                    Image("corssButton")
                }
            }
    }
}






