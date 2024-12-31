//
//  RecipeViewController.swift
//  recipe
//
//  Created by Hadia Thaniana on 1/21/23.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {

    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var recipeTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var managedObjectContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveCardAction(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        guard let ingredient = ingredientsTextView.text else { return }
        guard let recipe = recipeTextView.text else { return }
        saveCardToDatabase(name: name, ingredient: ingredient, recipe: recipe)
        
    }
    
    func saveCardToDatabase(name: String, ingredient: String, recipe: String) {
        let newRecipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: managedObjectContext)as! Recipe
        newRecipe.name = name
        newRecipe.ingredient = ingredient
        newRecipe.recipe = recipe
        
        do {
            try managedObjectContext.save()
            print("Recipe save succesfully")
        } catch {
            print("Could not save managedObjectContext state, recipe not save")
        }
    }
    
}
