//
//  CreateNewItemView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 07/03/2024.
//

import SwiftUI
struct CreateNewItemView: View {
    @FocusState var focus: FocusField?
    let foucsFieldType: FocusField
    let placeHolder: String
    @Binding var isEnabled: Bool
    @Binding var text: String
    @Binding var selectedEmoji: Emoji?
    
    let changeFieldStatusAction: () -> Void
    let addAction: () async -> Void
    let showEmojiPickerAction: (() -> Void)?
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                
                if let showEmojiPickerAction = showEmojiPickerAction {
                    //MARK: Emoji Picker Icon
                    Text(selectedEmoji?.value ?? "🗂️")
                        .onTapGesture {
                            showEmojiPickerAction()
                        }
                }
                
                //MARK: New Category Field
                TextField(placeHolder, text: $text)
                    .onChange(of: text) { newValue in
                        changeFieldStatusAction()
                    }
                    .onTapGesture { focus = foucsFieldType }
                    .focused($focus, equals: foucsFieldType)
                    .font(CustomFont.medium.font(size: 16))
                
                Image(systemName: "plus")
                    .foregroundColor(CustomColor.yellow)
                    .opacity(isEnabled ? 1.0 : 0.0)
                //MARK: Add category
                    .onTapGesture {
                        Task {
                            await addAction()
                        }
                        focus = nil
                        changeFieldStatusAction()
                    }
            }
            
            Rectangle()
                .frame(height: 1)
                .padding(.top, 4)
                .foregroundColor(isEnabled ? CustomColor.yellow: CustomColor.lightGrey)
        }
        .onChange(of: focus) { focused in
            if focused == foucsFieldType { isEnabled = true }
            else { isEnabled = false }
        }
    }
}
