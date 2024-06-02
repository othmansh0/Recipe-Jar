//
//  YouTubeModalView2.swift
//  Steps Screen Recipe Jar
//
//  Created by othman shahrouri on 2/8/23.
//

import SwiftUI

struct YouTubeModalView: View {
    @Binding var isShowing: Bool
    @State var videoTitle:String = "Good Old-Fashioned Pancakes"

    @State var videoSource:String = "YouTube"
    @State var channelName:String = "Recipe Jar"
    @State var postedVideoDate:String = "Dec 6, 2022"
    @State var videoDuration:String = "10:04"
    @State var showToast: Bool = false
    
    var body: some View{
        //MARK: Modal view
        HStack(spacing: 0){
         
            //MARK: YouTube image
            VStack{
                Image("paleo-pancakes")
                    .resizable()
                    .frame(width: 160,height: 100)
                    .cornerRadius(10)
                    .fixedSize()
                    .overlay{
                        Image(systemName: "play.circle.fill")
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 50))
                
                
                    .overlay(alignment: .bottomLeading){
                        Text(videoDuration)
                            .font(Font.custom("FiraSans-Medium", size: 10))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 15, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.black.opacity(0.6)))
                            .padding(.bottom,12)
                            .padding(.leading,4)
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.leading,25)
            .padding(.bottom,20)
            
            ZStack{

                Text(videoTitle)
                    .lineLimit(4)
                    .font(Font.custom("FiraSans-Medium", size: 16))
                    .padding(.leading,8)
                    .frame(maxWidth: .infinity, maxHeight: 120, alignment: .topLeading)
               VStack(spacing:4){
                    
                    //MARK: Video Source
                    HStack(spacing: 0){
                        Text(videoSource)
                        
                        
                            .foregroundColor(Color(uiColor: UIColor(red: 35.0/255, green: 41.0/255, blue: 70.0/255, alpha: 1)))
                        Text("- RecipeJar")
                        
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    
                    
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .bottomLeading)
                    
                    Text("Dec 6, 2022")
                        .frame(maxWidth: .infinity, maxHeight: 15, alignment: .bottomLeading)
                    
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                }
                .padding(.leading,8)
                .font(Font.custom("FiraSans-Medium", size: 11))
            }
        }
        
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        
        .background(
            
            ZStack {
                RoundedRectangle (cornerRadius: 15)
                Rectangle ()
                    .frame (height: 140 / 2)
            }
                .foregroundColor (.white)
      
        )
        
    }
    
 
}

struct YouTubeModalView_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeModalView(isShowing: .constant(true))
    }
}
