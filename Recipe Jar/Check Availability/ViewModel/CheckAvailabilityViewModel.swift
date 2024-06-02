//
//  CheckAvailabilityViewModel.swift
//  Whisk
//
//  Created by Nedine on 3/24/23.
//

import Foundation
import SwiftUI

class CheckAvailabilityViewModel: ObservableObject {
    @Published var frontDegree = 0.0
    @Published var backDegree = -90.0
    @Published var isFlipped = false
    @Published var durationAndDelay : CGFloat = 0.25
    
    
    @Published var stores = [
        Store(image: "Safeway", distance: 1.5, items: [Item(title: "item1", isCompleted: false),Item(title: "item2", isCompleted: false)]),
        
        Store(image: "Carrefour", distance: 2, items: [Item(title: "item3", isCompleted: false),Item(title: "item4", isCompleted: false)]),
        
        
        Store(image: "Miles", distance: 1, items: [Item(title: "item5", isCompleted: false),Item(title: "item6", isCompleted: false)])
    ]
    
    //    func flipCard (store: Store) {
    //        store.flippedStatus.isFlipped = !store.flippedStatus.isFlipped
    ////        store.flippedStatus.isFlipped.toggle()
    //        if store.flippedStatus.isFlipped {
    //                withAnimation(.linear(duration: durationAndDelay)) {
    //                    store.flippedStatus.backDegree = 90
    //                }
    //                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
    //                    store.flippedStatus.frontDegree = 0
    //                }
    //            } else {
    //                withAnimation(.linear(duration: durationAndDelay)) {
    //                    store.flippedStatus.frontDegree = -90
    //                }
    //                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
    //                    store.flippedStatus.backDegree = 0
    //                }
    //            }
    //        }
    
    func flipCard () {
        isFlipped = !isFlipped
        
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
    
    //
    //    func flipCard (store: Store) {
    //        store.flippedStatus.isFlipped.toggle()
    //print("flip card got called")
    //        if  store.flippedStatus.isFlipped {
    //
    //                withAnimation(.linear(duration: durationAndDelay)) {
    //                    store.flippedStatus.backDegree = 90
    //                }
    //                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
    //                    store.flippedStatus.frontDegree = 0
    //                }
    //            } else {
    //                withAnimation(.linear(duration: durationAndDelay)) {
    //                    store.flippedStatus.frontDegree = -90
    //                }
    //                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
    //                    store.flippedStatus.backDegree = 0
    //                }
    //            }
    //        }
    //
    //}
}
