//
//  StoreCardView.swift
//  Whisk
//
//  Created by Nedine on 3/19/23.
//

import SwiftUI

struct StoreCardFrontView: View {
    
    @State var store: Store
  //  @State var items = [Item(title: "beep", isCompleted: false),Item(title: "boop", isCompleted: false)]
    @Binding var degree : Double
    @StateObject var vm = CheckAvailabilityViewModel()
    
    var body: some View {
        
        VStack {
            Image(store.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding()
            
            HStack (spacing: 30){
                VStack(alignment: .leading, spacing: 2) {
                    Text("DISTANCE")
                        .font(.system(size: 10))
                        .foregroundColor(Color("greyfont"))
                    
                    
                    Text("\(store.distance, specifier: "%.1f") Km")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                   
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("ITEMS")
                        .font(.system(size: 10))
                        .foregroundColor(Color("greyfont"))
                    
                    Text("\(store.items.count)")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                
                }
            }
            .padding(.bottom, 5)
            .frame(width: 155, height: 59)
            .background(Color("greycard").opacity(0.27))
            
        }
        .frame(width: 155,height: 187)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("greycard"))
        )
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
//        .onTapGesture {
////            store.CardisFlipped.toggle()
//            vm.flipCard(store: store)
//            
//        }
    }
    
        
    }
    


//struct StoreCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreCardView(store: Store(image: "Miles", distance: 1.5, items: [Item(title: "beep", isCompleted: false),Item(title: "boop", isCompleted: false)]))
//    }
//}

@ViewBuilder
func StoreCardFrontView2(store: Store,degree : Double,vm: CheckAvailabilityViewModel) -> some View{
    
        VStack {
            Image(store.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding()
            
            HStack (spacing: 30){
                VStack(alignment: .leading, spacing: 2) {
                    Text("DISTANCE")
                        .font(.system(size: 10))
                        .foregroundColor(Color("greyfont"))
                    
                    
                    Text("\(store.distance, specifier: "%.1f") Km")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                   
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("ITEMS")
                        .font(.system(size: 10))
                        .foregroundColor(Color("greyfont"))
                    
                    Text("\(store.items.count)")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                
                }
            }
            .padding(.bottom, 5)
            .frame(width: 155, height: 59)
            .background(Color("greycard").opacity(0.27))
            
        }
        .frame(width: 155,height: 187)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("greycard"))
        )
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
//        .onTapGesture {
////            store.CardisFlipped.toggle()
//            vm.flipCard(store: store)
//
//        }
    
    
        
    }
