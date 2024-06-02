import SwiftUI
import Kingfisher
struct PickedRecipeView: View {
    var recipe: Recipe
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            KFImage(URL(string: recipe.pictureUrl ?? "https://dummyurl.com/dummy/path/defaultRecipeImage/"))
                .placeholder {
                    Image("defaultRecipeImage")
                        .resizable()
                        .cornerRadius(8)
                        .frame(width: 150, height: 134, alignment: .center)
                }
                .retry(maxCount: 3, interval: .seconds(5))
                .resizable()
                .cornerRadius(8)
                .frame(width: 150, height: 134, alignment: .center)
                .overlay(
                    HStack(spacing: 2) {
                        if let time = recipe.time, time != 0 {
                            Text("\(time) Mins")
                            Text("|")
                        }
                        Text("1 serving")
                    }
                        .font(CustomFont.regular.font(size: 11))
                        .foregroundStyle(.white)
                        .padding(4)
                        .glassBackground(color: Color(red: 0.62, green: 0.57, blue: 0.63),removeAllFilters: false,opactiy:0.74,blurRadius:9,radius: 4)
                        .padding(4)
                    ,alignment: .bottomLeading
                )
            Text(recipe.title)
                .frame(width: 122,alignment: .leading)
                .lineLimit(2)
                .font(CustomFont.regular.font(size: 13))
                .padding(.top,12)
        }
    }
}
