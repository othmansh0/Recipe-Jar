import UIKit
import SwiftUI

@MainActor
final class FolderViewModel: BaseVM {
    
    private var networkService: Networkable
    
    
    @Published private(set) var isFoldersReceived = false
    @Published var showCreateFolder = false
    
    @Published var folders = [Folder]()
    
    @Published var isRename = false
    @Published var rename = ""
    @Published var newFolderName = ""
    
    @Published var selectedFolder = Folder(name: "dummy", orderNumber: -1, recenltyRecipesAdded: [], id: -1)
    
    @Published var presentAlert = false
    
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
    }
    
    
    func getFolders(hideLoading: Bool) async {
           if let fetchedFolders: [Folder] = loadJson(filename: "MockRecipeFolders") {
               DispatchQueue.main.async {
                   self.folders = fetchedFolders
                   self.isFoldersReceived = true
               }
           }
       }
}


extension FolderViewModel {
    
    func deleteFolder() async {
        await performNetworkRequest(skipErrors: true,{
            try await networkService.sendRequest(endpoint: FolderEndPoint.deleteFolder(id: selectedFolder.id))
        })
        folders.remove(at: selectedFolder.orderNumber - 1)
        //each time an item is removed re-assign folders orderIDs
        for i in 0..<folders.count {  folders[i].orderNumber = i + 1 }
    }
    
    func renameFolder() async  {
        selectedFolder.name = rename
        folders[selectedFolder.orderNumber - 1].name = rename
        
        await performNetworkRequest(skipErrors: true,{
            try await networkService.sendRequest(endpoint: FolderEndPoint.renameFolder(categoryID: selectedFolder.id, name: rename))
        })
        rename = ""
    }
    
    
    func createFolder() async -> Folder? {
        
        if let createdFolder: Folder = await performNetworkRequest({
            try await networkService.sendRequest(endpoint: FolderEndPoint.createFolder(name: newFolderName))
        }) {
            folders.append(createdFolder)
            newFolderName = ""
            return createdFolder
        }
        
        newFolderName = ""
        return nil
        
    }
    
    
}
