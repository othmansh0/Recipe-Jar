//
//  StoreModel.swift
//  Whisk
//
//  Created by Nedine on 3/21/23.
//

import Foundation
import SwiftUI

class Store:ObservableObject {
    let image: String
    let distance: Double
    let items: [Item]
  
//    @Published var flippedStatus: Flip
    
    init(image: String, distance: Double, items: [Item]) {
        self.image = image
        self.distance = distance
        self.items = items
//        self.orderID = orderID
//        self.flippedStatus = flippedStatus
    }
}

class Flip:ObservableObject {
    @Published var isFlipped = false
    @Published var frontDegree = 0.0
    @Published var backDegree = -90.0
}
