//
//  FolderImageView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 1/05/2024.
//

import SwiftUI
import Kingfisher
struct FolderImageView: View {
    let urlString: String?
    let size: CGSize
    var body: some View {
        KFImage(URL(string: urlString ?? "https://dummyurl.com/dummy/path/defaultRecipeImage/"))
            .placeholder {
                Image(.recipeFolderDefault)
                    .resizable()
                    .cornerRadius(5)
                    .frame(width: 71, height: 71)
            }
            .retry(maxCount: 3, interval: .seconds(5))
            .resizable()
            .cornerRadius(5)
            .frame(width: 71, height: 71)
    }
}
