import SwiftUI

struct PopUpMenuView <Data>: View where Data: Nameable{
    var menuTitle: String
    var menuMsg: String
    let items: [Data]
    let isPresented: Bool
    let action: (Int) -> Void
    var body: some View {
        ZStack {
            if isPresented {
                VStack (alignment: .center, spacing: 10){
                    Text(menuTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(uiColor: .navy))
                        .font(.title3)
                        .padding(.top,10)
                    
                    Text(menuMsg)
                        .padding(.bottom,15)
                    
                    List {
                        ForEach(Array(zip(items.indices, items)), id:\.0) { index,item in
                            HStack {
                                Text(item.name)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { action(index) }
                        }
                    }
                    .listStyle(.plain)
                }
                .foregroundColor(Color(uiColor: .navy))
                .padding(.horizontal,20)
                .padding(.bottom,25)
                .padding(.top,15)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 1)
                .frame(width: 330, height:230)
                .transition(.scale)
                .animation(.easeInOut(duration: 0.3))
            }
            else {EmptyView()}
        }
        //        .opacity(isPresented ? 1 : 0)
        
        
        //        .isHidden(!isPresented, remove: !isPresented)
    }
}

protocol Nameable {
    var name: String { get }
    var id: Int { get }
}
