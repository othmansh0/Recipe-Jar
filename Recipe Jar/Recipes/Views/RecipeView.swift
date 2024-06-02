import SwiftUI
import Kingfisher
struct RecipeView: View {
    let recipe: Recipe
    var vm: RecipeViewModelImpl
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            VStack(alignment: .leading,spacing: 0) {
                Text(recipe.title.trimmingCharacters(in: CharacterSet(charactersIn: "Recipe by Tasty")))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .font(CustomFont.medium.font(size: 12))
                    .padding(.top, 15)
                Group {
                    if let time = recipe.time, time != 0 { Text("\(time) Mins | 1 Serving") }
                    else { Text("1 Serving") }
                }
                .font(CustomFont.regular.font(size: 10))
                .foregroundColor(CustomColor.greyCard)
                .padding(.top,5)
                .padding(.bottom, 15)
            }
            .padding(.leading,8)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: 51)
            .background(.ultraThinMaterial.opacity(0.85))
            .cornerRadius(9)
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .background (
                Rectangle()
                    .fill(CustomColor.purple.opacity(0.5))
                    .frame(width: 135, height: 43)
                    .cornerRadius(9)
                    .blur(radius: 6)
            )
            .padding(.bottom, 10)
        }
        .frame(width: 155.23, height: 187,alignment: .bottom)
        .background (
            KFImage(URL(string: recipe.pictureUrl ?? "https://dummyurl.com/dummy/path/defaultRecipeImage/"))
                .placeholder {
                    Image(.recipeFolderDefault)
                        .resizable()
                        .aspectRatio(0.83010695, contentMode: .fill)
                        .cornerRadius(9)
                }
                .retry(maxCount: 3, interval: .seconds(5))
                .resizable()
                .cornerRadius(9)
        )
    }
}
