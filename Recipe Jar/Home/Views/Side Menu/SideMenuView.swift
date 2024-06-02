import SwiftUI

struct SideMenuView: View {
    let folders: [Folder]
    let categories: [ShoppingListCategory]
    let openFolder: (Folder) -> Void
    let openShoppingList: (ShoppingListCategory) -> Void
    let openHelpScreen: () -> Void
    private let leadingPadding = 16.0
    
    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            SideMenuFirstSectionView()
                .padding(.leading,leadingPadding)
                .padding(.top,35)
            SideMenuDividerView()
                .padding(.top,20)
            SideMenuSecondSectionView(folders: folders, categories: categories, openFolder: openFolder, openShoppingList: openShoppingList)
                .padding(.leading,leadingPadding)
                .padding(.top,8)
            Spacer()
            SideMenuHelpView(openHelpScreen: openHelpScreen)
                .padding(.leading,leadingPadding)
        }
        .frame(maxWidth: .infinity,alignment: .topLeading)
    }
}

