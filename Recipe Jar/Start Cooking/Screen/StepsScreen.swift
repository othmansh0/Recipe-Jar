import SwiftUI
import UIKit

struct StepsScreen: View {
    
    @Binding var isPresentingStepsScreen: Bool
    @ObservedObject var vm: StartCookingViewModel
    @ObservedObject var recipeViewModel: RecipeViewModelImpl
    let openYouTubeScreen: (VideoURL) -> Void

    var body: some View {
        BaseScreen(isLoading: [$vm.isLoading],isLoadingHidden: .constant(true),isTabBarHidden: true, error: $vm.error) {
            VStack {
                //MARK: Steps
                SnapCarousel(spacing:10,
                             trailingSpace:0,
                             index: $vm.currentPage,
                             items: ((vm.selectedRecipe.steps ?? Step.getDummyStep())) ,
                             isEnglish:true
                             ,autoPlayDuration: nil,
                             stopAutoPlayAfterOneCyle: false) { step in
                    StepView(step: step)
                        .redactShimmer(condition: vm.isLoading)
                        .disabled(recipeViewModel.isLoading)
                }
                             .clipped()
                             .frame(height: UIScreen.screenHeight * 0.23474178,alignment: .center)
                             .padding(.top,UIScreen.screenHeight * 0.11737089)
                             .padding(.horizontal,45)
                
                PageIndicatorView(numberOfPages: vm.isLoading ? 5 : vm.selectedRecipe.steps?.count ?? 0, currentIndex: vm.currentPage)
                    .padding(.top,10)
                    .redactShimmer(condition: vm.isLoading)

                Spacer()
                StepsButtonsView(backAction: {vm.backStep()}, nextAction: {vm.nextStep()}, checkReading: {vm.checkReading()})
                .onChange(of: vm.currentPage) { newValue in
                    vm.checkReading()
                }
            }
            .overlay(alignment: .bottom) {
                Group{
                    youtubeModalView
                        .ignoresSafeArea()
                }
            }
            .background(
                Group {
                    if vm.showYoutubeModalView  {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { vm.showYoutubeModalView = false }
                    }
                    else {
                        Color.clear
                    }
                }
            )
        }
        .task {
            if let recipeID =  vm.selectedRecipe.id {
                await vm.getSteps()
            }
        }
        .onDisappear {
            vm.currentPage = 0
        }
        .onChange(of: vm.currentPage) { _ in
            if vm.isReadingOn {
                vm.checkReading()
            }
        }
        .alert(isPresented: $recipeViewModel.showAlert){
            Alert(title: Text("Error"), message: Text(recipeViewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $vm.hasError){
            Alert(title: Text("Error"), message: Text(vm.localError!), dismissButton: .default(Text("OK")))
        }
        .animation(.smooth(duration: vm.showYoutubeModalView ? 0.2 : 0.9), value: vm.showYoutubeModalView)
    }
    @ViewBuilder
    var youtubeModalView: some View {
        if vm.showYoutubeModalView {
            ZStack(alignment: .bottom) {
                if let youtubeLink = vm.selectedRecipe.videoUrl, let title =  vm.selectedRecipe.videoTitle,let image = vm.selectedRecipe.videoImageUrl {
                    let videoObj = VideoURL(youtubeLink: youtubeLink, title: title, image: image, channelName:  vm.selectedRecipe.videoChannelName, duration:  vm.selectedRecipe.videoDuration, videoPostedDate:  vm.selectedRecipe.videoPostedDate)
                    YouTubeModalView(isShowing: $vm.showYoutubeModalView, videoObject: videoObj,isPresentingStepsScreen: $isPresentingStepsScreen, openYouTubeScreen: openYouTubeScreen)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.all)
            .transition(.move(edge: vm.showYoutubeModalView ? .bottom : .top))
        }
    }
}
