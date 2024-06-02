//
//  SearchFieldView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 25/12/2023.
//

import SwiftUI

struct SearchFieldView: View {
    
    @Binding var searchText: String
    @FocusState var focus: FocusElement?
    let cancelAction: () -> Void
    
    var body: some View {
        HStack (spacing: 10){
            HStack {
                Image("magnify")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(uiColor: UIColor(red: 0.365, green: 0.388, blue: 0.416, alpha: 1)))
                    .padding(.leading,15)
                TextField("", text: $searchText)
                    .placeholder(when: searchText.isEmpty) {
                        Text("Search in saved recipes")
                            .foregroundColor(Color(uiColor:UIColor(red: 0.365, green: 0.388, blue: 0.416, alpha: 1)))
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 2)
                    .focused($focus,equals: .search)
                    .foregroundColor(Color(uiColor: .navy))
                    .disableAutocorrection(true)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(uiColor: .navy))
                            .padding()
                            .isHidden(searchText.isEmpty || (focus==nil),remove: searchText.isEmpty || (focus==nil))
                            .onTapGesture {
                                cancelAction()
                            }
                    }
                    .onTapGesture {}
            }
            .frame(height: 46)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .fill(CustomColor.searchColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color("greysearch"))
            )
            
            Text("Cancel")
                .frame(height: 46)
                .foregroundColor(Color(uiColor: .navy))
                .onTapGesture { cancelAction() }
                .isHidden(focus != .search, remove: focus != .search)
        }
        .animation(.smooth(duration: 0.1),value: focus)
    }
}
