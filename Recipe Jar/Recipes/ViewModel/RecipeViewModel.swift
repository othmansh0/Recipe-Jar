import Foundation
import UIKit
@MainActor //To perform on main thread in order to update our UI
final class RecipeViewModelImpl: BaseVM {
    
    @Published var recipeWithCategories: RecipeWithCategories?
    @Published  var recipes: [Recipe] = []
    @Published var selectedRecipe: Recipe?
    @Published var selectedRecipeIngredients: [Ingredient] = []
    @Published var isSharePDFPresented = false
    
    //MARK: WebExtension
    @Published  var selectedFolder:Folder?
    var listCategories:[ShoppingListCategory]?
    @Published  var selectedList:ShoppingListCategory?
    //MARK: Error
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var networkService: Networkable
    
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
        super.init()
        isLoading = true
    }
    
    
    func scrapeRecipeDetails(recipeURL: String) async {
        if let result: RecipeWithCategories = try await performNetworkRequest({
            try await networkService.sendRequest(endpoint: RecipeEndPoint.getRecipeInfo(url: recipeURL))
        }) {
            recipeWithCategories  = result
        }
    }
    
    func deleteRecipe()async{
        recipes.removeAll{ $0.id == selectedRecipe?.id }
        do {
            if let recipeID = selectedRecipe?.id{
                try await networkService.sendRequest(endpoint: RecipeEndPoint.deleteRecipe(id: recipeID))
            }
        } catch  {
            handleError(error: "Sorry, we couldn't delete recipe")
        }
    }
    
    func getAllRecipes(categoryID: Int) async {
        if let result: [Recipe] = try await performNetworkRequest({
            try await networkService.sendRequest(endpoint: RecipeEndPoint.getAllRecipes(categoryID: categoryID))
        }) {
            recipes  = result
        }
    }
    
    func getRecipeIngredients(recipeID: Int, skipLoading: Bool = false) async {
          if let result: [Ingredient] = loadJson(filename: "MockRecipeIngredients") {
              DispatchQueue.main.async {
                  self.selectedRecipeIngredients = result
              }
          }
      }
    
     func getRecipeSteps(recipeID: Int? = nil, skipLoading: Bool = false)  -> [Step] {
          if let result: [Step] = loadJson(filename: "MockRecipeSteps") {
              DispatchQueue.main.async {
                  self.selectedRecipe?.steps = result
              }
              return result
          }
        return []
      }
    
    func saveRecipe() async{
        guard let recipeWithCategories = recipeWithCategories else { return }
        var recipe = recipeWithCategories.recipe
        var addToShoppingList = false
        if let ingredients = recipe.ingredients {
            for i in 0..<ingredients.count {
                ingredients[i].orderNumber = i+1
            }
        }
        
        if var steps = recipe.steps {
            for i in 0..<steps.count {
                steps[i].orderNumber = i+1
            }
        }
        
        if selectedList != nil {
            addToShoppingList = true
        }
        
        let ingredientsArray = recipe.ingredients
        let stepsArray = recipe.steps
        let encoder = JSONEncoder()
        guard let ingredientsData = try? encoder.encode(ingredientsArray),let stepsData = try? encoder.encode(stepsArray) else { return }
        let ingredientsJSONString = String(data: ingredientsData, encoding: .utf8)!
        let stepsJSONString = String(data: stepsData, encoding: .utf8)!
        let ingredientsDictionary = try! JSONSerialization.jsonObject(with: ingredientsData, options: .allowFragments) as? [[String: Any]]
        let stepsDictionary = try! JSONSerialization.jsonObject(with: stepsData, options: .allowFragments) as? [[String: Any]]
        do {
            try await networkService.sendRequest(endpoint: RecipeEndPoint.saveRecipe(recipeWithCategories: recipeWithCategories, selectedFolder: selectedFolder!, selectedList: selectedList, addToShoppingList: addToShoppingList, ingredientsArray: ingredientsDictionary, stepsArray: stepsDictionary))
        } catch  {
            handleError(error: "Could not get recipe")
        }
    }
}

extension RecipeViewModelImpl{
    func handleError(error: String) {
        DispatchQueue.main.async {
            self.errorMessage = error
            self.showAlert.toggle()
        }
    }
}



//MARK: Share Recipe
extension RecipeViewModelImpl {
    
    func generatePDFData(recipe: Recipe) async -> Data {
        selectedRecipe?.steps = getRecipeSteps()
           let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595.2, height: 841.8)) // A4 size
           let data = renderer.pdfData { (context) in
               let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
               context.beginPage()
               let pageBounds = UIGraphicsGetPDFContextBounds()

               let titleAttributes = [
                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
                   NSAttributedString.Key.foregroundColor: UIColor.black
               ]
               let title = recipe.title
               let titleSize = title.size(withAttributes: titleAttributes)
               let maxTitleWidth = pageBounds.width - 100
               if titleSize.width > maxTitleWidth {
                   let fontSize = 24 * (maxTitleWidth / titleSize.width)
                   let adjustedTitleAttributes = [
                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
                       NSAttributedString.Key.foregroundColor: UIColor.black
                   ]
                   let adjustedTitleSize = title.size(withAttributes: adjustedTitleAttributes)
                   let adjustedTitleRect = CGRect(x: (pageBounds.width - adjustedTitleSize.width) / 2, y: 50, width: adjustedTitleSize.width, height: adjustedTitleSize.height)
                   title.draw(in: adjustedTitleRect, withAttributes: adjustedTitleAttributes)
               } else {
                   let titleRect = CGRect(x: (pageBounds.width - titleSize.width) / 2, y: 50, width: titleSize.width, height: titleSize.height)
                   title.draw(in: titleRect, withAttributes: titleAttributes)
               }

               let ingredientsTitleAttributes = [
                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                   NSAttributedString.Key.foregroundColor: UIColor.black
               ]
               let ingredientsTitle = "Ingredients"
               let ingredientsTitleSize = ingredientsTitle.size(withAttributes: ingredientsTitleAttributes)
               let ingredientsTitleRect = CGRect(x: 50, y: 100, width: ingredientsTitleSize.width, height: ingredientsTitleSize.height)
               ingredientsTitle.draw(in: ingredientsTitleRect, withAttributes: ingredientsTitleAttributes)

               var yPosition: CGFloat = 150
               var pageCount = 1
               for ingredient in selectedRecipeIngredients {
                   var ingredientString = ""
                   if let quantity = ingredient.quantity {
                       ingredientString += "\(quantity) "
                   }
                   if let unit = ingredient.unit {
                       ingredientString += "\(unit) "
                   }
                   ingredientString += ingredient.name
                   let ingredientAttributes = [
                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                       NSAttributedString.Key.foregroundColor: UIColor.black
                   ]
                   let maxIngredientWidth = pageBounds.width - 100
                   let ingredientRect = CGRect(x: 50, y: yPosition, width: maxIngredientWidth, height: CGFloat.greatestFiniteMagnitude)
                   let ingredientAttributedString = NSAttributedString(string: ingredientString, attributes: ingredientAttributes)
                   let ingredientTextRect = ingredientAttributedString.boundingRect(with: CGSize(width: maxIngredientWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
                   ingredientAttributedString.draw(in: ingredientRect)
                   yPosition += ingredientTextRect.height + 5
                   if yPosition > pageBounds.height - 100 {
                       pageCount += 1
                       context.beginPage()
                       yPosition = 150
                   }
               }

               let stepsTitleAttributes = [
                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                   NSAttributedString.Key.foregroundColor: UIColor.black
               ]
               let stepsTitle = "Steps"
               let stepsTitleSize = stepsTitle.size(withAttributes: stepsTitleAttributes)
               let stepsTitleRect = CGRect(x: 50, y: yPosition + 20, width: stepsTitleSize.width, height: stepsTitleSize.height)
               stepsTitle.draw(in: stepsTitleRect, withAttributes: stepsTitleAttributes)

               yPosition += 50
               guard let steps = selectedRecipe?.steps else { return }
               for (index, step) in steps.enumerated() {
                   let stepDescription = step.description
                   let maxStepWidth = pageBounds.width - 100
                   let stepString = "\(index + 1). \(stepDescription)"
                   let stepAttributes = [
                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                       NSAttributedString.Key.foregroundColor: UIColor.black
                   ]
                   let stepRect = CGRect(x: 50, y: yPosition, width: maxStepWidth, height: CGFloat.greatestFiniteMagnitude)
                   let stepAttributedString = NSAttributedString(string: stepString, attributes: stepAttributes)
                   let stepTextRect = stepAttributedString.boundingRect(with: CGSize(width: maxStepWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
                   stepAttributedString.draw(in: stepRect)
                   yPosition += stepTextRect.height + 5
                   if yPosition > pageBounds.height - 100 {
                       pageCount += 1
                       context.beginPage()
                       yPosition = 150
                   }
               }
           }
           return data
       }
    
    
    func generateShareLink(recipe: Recipe) async -> ShareLink? {
        isSharePDFPresented = true
        let pdfData = await generatePDFData(recipe: recipe)
        let fileName = "\(recipe.title).pdf"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        do {
            try pdfData.write(to: fileURL)
        } catch {
            return nil
        }
        
        return ShareLink(url: fileURL)
    }
    
}
