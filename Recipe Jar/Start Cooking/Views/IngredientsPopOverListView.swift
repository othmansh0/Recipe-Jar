import SwiftUI
struct IngredientsPopOverListView: View {
    var ingredients: [Ingredient]
    var scale: Double

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading,spacing: 5) {
                ForEach(Array(zip(ingredients.indices, ingredients)), id: \.1.name) { index,ingredient in
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .imageScale(.small)
                        if let quantity = ingredient.quantity {
                            Text("\(quantity * scale, specifier: "%.2f")")
                                .isHidden(quantity == 0, remove: false)
                                .overlay {
                                        Text(" - ")
                                        .isHidden(quantity != 0, remove: quantity != 0)
                                }
                        }
                        Text(ingredient.name)
                    }
                    .padding(.top,index == 0 ? 16 : 0)
                    .padding(.bottom,index == ingredients.count - 1 ? 16 : 0)
                }
            }
        }
        .frame(maxWidth: .infinity,alignment: .topLeading)
        .padding(.horizontal,20)
    }
}
