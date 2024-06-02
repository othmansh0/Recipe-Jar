//
//  StoreCardBackView.swift
//  Whisk
//
//  Created by Nedine on 3/24/23.
//

import SwiftUI

struct StoreCardBackView: View {
    
    @State var store: Store
  //  @State var items = [Item(title: "beep", isCompleted: false),Item(title: "boop", isCompleted: false)]
    @Binding var degree : Double
    @StateObject var vm = CheckAvailabilityViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Text(store.image)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color("purple"))
                .padding(.horizontal,15)
                .padding(.top,15)
            
            Divider()
                .padding(.horizontal,15)
                .padding(.bottom,10)
                .padding(.top,-5)
         
            
            ForEach(store.items) { item in
                Text(item.title)
            }
            .foregroundColor(Color("navy"))
            .padding(.horizontal,15)
         
                
              Spacer()
            
        }
        .frame(width: 155, height: 187)
        .background(.white)
//        .padding(.horizontal,5)
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

//struct StoreCardBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreCardBackView(store: Store(image: "Miles", distance: 1.5, items: [Item(title: "beep", isCompleted: false),Item(title: "boop", isCompleted: false)]))
//    }
//}

@ViewBuilder
func StoreCardBackView2(store: Store, degree : Double,vm: CheckAvailabilityViewModel) -> some View {
    
   
        VStack (alignment: .leading) {
            
            Text(store.image)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color("purple"))
                .padding(.horizontal,15)
                .padding(.top,15)
            
            Divider()
                .padding(.horizontal,15)
                .padding(.bottom,10)
                .padding(.top,-5)
         
            
            ForEach(store.items) { item in
                Text(item.title)
            }
            .foregroundColor(Color("navy"))
            .padding(.horizontal,15)
         
                
              Spacer()
            
        }
        .frame(width: 155, height: 187)
        .background(.white)
//        .padding(.horizontal,5)
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
