//
//  SwipeModifier.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 07/03/2024.
//

import SwiftUI
struct SwipeModifier: ViewModifier {
    
    let color: Color
    let icon: String
    let action: () -> ()
    
    @AppStorage("MySwipeActive") var mySwipeActive = false
    
    @State private var contentWidth: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var isDeleting: Bool = false
    @State private var isActive: Bool = false
    @State private var dragX: CGFloat = 0
    @State private var iconOffset: CGFloat = 40
    
    let minimumDistance: CGFloat = 20
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
                .overlay(GeometryReader { geo in Color.clear.onAppear { contentWidth = geo.size.width }})
                .offset(x: -dragX)
            
            Group {
                color
                Image(systemName: icon)
                    .symbolVariant(.fill)
                    .foregroundColor(.white)
                    .offset(x: isDeleting ? 40 - dragX/2 : iconOffset)
            }
            .frame(width: max(dragX, 0))
            .onTapGesture {
                withAnimation {
                    action()
                    resetSwipeState()
                }
                
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
                  withAnimation {
                      resetSwipeState()
                  }
              }
        .gesture(DragGesture(minimumDistance: minimumDistance)
            .onChanged { value in
                if !isDragging && !isActive {
                    mySwipeActive = false
                    isDragging = true
                }
                
                if value.translation.width < 0 {
                    dragX = -min(value.translation.width + minimumDistance, 0)
                } else if isActive {
                    dragX = max(80 - value.translation.width + minimumDistance, -30)
                }
                
                iconOffset = dragX > 80 ? -40 + dragX/2 : 40 - dragX/2
                withAnimation(.easeOut(duration: 0.3)) { isDeleting = dragX > contentWidth * 0.75 }
                
                if value.translation.width <= -contentWidth {
                    withAnimation { action() }
                    mySwipeActive = false
                    isDragging = false
                    isActive = false
                }
            }
            .onEnded { value in
                withAnimation(.easeOut) {
                    isDragging = false
                    
                    if value.translation.width < -60 && !isActive {
                        isActive = true
                        mySwipeActive = true
                    } else {
                        isActive = false
                        mySwipeActive = false
                    }
                    
                    if isDeleting { action() ; return }
                    
                    if isActive {
                        dragX = 80
                        iconOffset = 0
                    } else {
                        dragX = 0
                        isDeleting = false
                    }
                }
            }
        )
        .onChange(of: mySwipeActive) { newValue in
            if newValue == false && !isDragging {
                withAnimation {
                    dragX = 0
                    isActive = false
                    isDeleting = false
                    iconOffset = 40
                }
            }
        }
        // Ensure the modifier does not change the vertical size of the view.
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func resetSwipeState() {
          isActive = false
          dragX = 0
          iconOffset = 40
          isDragging = false
          isDeleting = false
      }
}
extension View {
    func swipeModifier(color: Color = .red,
                       icon: String = "trash",
                       action: @escaping () -> ()) -> some View {
        self.modifier(SwipeModifier(color: color, icon: icon, action: action))
    }
}
