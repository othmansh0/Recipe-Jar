//
//  CheckAvailabilityScreen.swift
//  Whisk
//
//  Created by Nedine on 3/19/23.
//

import SwiftUI

struct CheckAvailabilityScreen: View {
    
    
    @StateObject var vm = CheckAvailabilityViewModel()
//    @State var enabled = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
      
            ZStack {
                Color("greycheck")
                    .ignoresSafeArea()
                
                VStack (alignment: .leading){
                    
                    HStack {
                        Image("avback")
                            .padding(.trailing, 10)
                        
                        Text("Availability")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("purple"))
                  
                    }
                    
                    
                    
                    ScrollView {
                        LazyVGrid(columns: columns,spacing: 20) {
                            ForEach(0..<vm.stores.count, id:\.self) { num in
                                ZStack {
                                    StoreCardBackView(store: vm.stores[num], degree: $vm.backDegree)
                                    StoreCardFrontView(store: vm.stores[num], degree: $vm.frontDegree)
                    
//                                    StoreCardBackView(store: vm.stores[num],degree: $vm.stores[num].flippedStatus.backDegree)
                            
//                                    StoreCardFrontView(store: vm.stores[num],degree: $vm.stores[num].flippedStatus.frontDegree)
    
        
                                   
                                    
                                    
                                }
                                .onTapGesture {
                                    vm.flipCard()
                                }
                                
                            }
                            .onTapGesture {
                                
                              
                            }
                        }
                        .padding(.top,20)
                        
                        
                        
                    }

                }
                .padding(.horizontal,30)
                
            }
            
        }
        

    }



struct CheckAvailabilityScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckAvailabilityScreen()
    }
}
