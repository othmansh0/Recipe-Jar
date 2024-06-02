import SwiftUI
struct FoldersScreen: View {
    
    @ObservedObject var vm: FolderViewModel
    let showRecipes: (Int,String) -> Void
    
    @State private var folderName: String = ""
    @State private var refresherState: RefresherState = RefresherState(mode: .refreshing, modeAnimated: .refreshing)
    @State private var isRefreshing = false
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        BaseScreen(isLoading: [$vm.isLoading],isLoadingHidden: .constant(true), error: $vm.error) {
            ScrollView(showsIndicators: false) {
                LazyVGrid (columns: columns, spacing: 27) {
                    ForEach(vm.isFoldersReceived ? vm.folders : Folder.dummyFolders(count: 5),id: \.id){ folder in
                        FolderView(folder: folder, vm: vm, showRecipes: showRecipes)
                            .redactShimmer(condition: !vm.isFoldersReceived || isRefreshing)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            .refresher(
                isRefreshing: $isRefreshing,
                refreshView: { bindingState in
                    LottieRefreshView(state: $refresherState)
                }, action: {
                    isRefreshing = true
//                    await vm.getFolders(hideLoading: refreshingState)
                    try! await Task.sleep(nanoseconds: 2_000_000_000)
                    isRefreshing = false
                }
            )
            .alert("New Folder", isPresented: $vm.showCreateFolder, actions: {
                TextField("Folder", text: $vm.newFolderName)
                
                Button("Create", action: {
                    withAnimation {
                        Task { await vm.createFolder() }
                    }
                    folderName = ""
                })
                Button("Cancel", role: .cancel, action: {
                    folderName = ""
                })
            }, message: {
                Text("Enter a name for this folder.")
            })
            
            .alert("Rename",isPresented: $vm.isRename){
                TextField("New name",text: $vm.rename)
                Button("Rename"){
                    Task{ await vm.renameFolder() }
                }
                Button("Cancel", role: .cancel, action: {
                    folderName = ""
                })
            }
        }        
        .onFirstAppearAsync { await vm.getFolders(hideLoading: isRefreshing) }
        .disabled(isRefreshing || vm.isLoading)
    }
}
