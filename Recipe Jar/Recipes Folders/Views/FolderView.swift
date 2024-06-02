import SwiftUI
import UIKit


struct FolderView: View {
    
    let folder:Folder
    let vm:FolderViewModel
    let showRecipes: (Int,String) -> Void
    let recipeSize = CGSize(width: 71, height: 71)
    private var gridItems: [GridItem] { [GridItem(.flexible(minimum: 0, maximum: recipeSize.width)),
                                         GridItem(.flexible(minimum: 0, maximum: recipeSize.width))]}
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 5) {
            ForEach(0..<4) { index in
                Group {
                    if let recentlyRecipesAdded = folder.recenltyRecipesAdded, index < folder.recenltyRecipesAdded?.count ?? 0 {
                        FolderImageView(urlString: recentlyRecipesAdded[index], size: recipeSize)
                    } else {
                        Rectangle()
                            .fill(Color(hex:"F1F1F1"))
                    }
                }
                .frame(width: recipeSize.width, height: recipeSize.height)
                .cornerRadius(5)
                .onTapGesture {
                    vm.selectedFolder = folder
                    showRecipes(folder.id, folder.name)
                }
            }
        }
        .frame(width:163)
        .padding(.bottom,22)
        .padding(.top,10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex:"F1F1F1"))
        )
        .overlay(alignment: .bottom) {
            FolderLabelView(title: folder.name, navigateAction: navigateAction,
                            firstAction: {
                Task{@MainActor in
                    vm.selectedFolder = folder
                    vm.isRename = true
                }
            }, secondAction: {
                Task{@MainActor in
                    vm.selectedFolder = folder
                    await vm.deleteFolder()
                }
            })
        }
    }
    
    @MainActor func navigateAction() {
        vm.selectedFolder = folder
        showRecipes(folder.id, folder.name)
    }
}







