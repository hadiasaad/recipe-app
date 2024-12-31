//
//  ViewController.swift
//  recipe
//
//  Created by Hadia Thaniana on 1/18/23.
//


import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    enum DisplayMode {
        case ingredientsFirst
        case recipeFirst
    }
    
    var currentDisplayMode : DisplayMode = .ingredientsFirst
    
    var managedObjectContext : NSManagedObjectContext!
    var listOfCards = [Recipe]()
    var currentCard : Recipe?
    var listOfName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        fetchCards()
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCards()
    }
    
    func fetchCards(){
        let fetchRequest : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
            listOfCards = try managedObjectContext.fetch(fetchRequest)
            print("Recipes fetched succesfully")
            //printCards()
            if !listOfCards.isEmpty {
                for card in listOfCards {
                    if !listOfName.contains(card.name!) {
                        listOfName.append(card.name!)
                    }
                }
            }
        } catch {
            print("Could not fetch data from managedObjectContext")
        }
    }
    
    func printCards() {
        for card in listOfCards {
            print(card.ingredient!)
            print(card.recipe!)
        }
    }
    
    func displayCard() {
        if listOfCards.count < 1 {
            recipeLabel.text = "No cards to display"
            return
        }
        let randomIndex = Int(arc4random_uniform(UInt32(listOfCards.count)))
        currentCard = listOfCards[randomIndex]
        if let displayCard = currentCard {
            guard let nameText = nameTextField.text else { return }
            if nameText == "" {
                displayQuestionOrAnswer(cardToDisplay: displayCard)
            } else if !listOfName.contains(nameText){
                recipeLabel.text = "No cards with that name"
            } else if displayCard.name == nameText {
                displayQuestionOrAnswer(cardToDisplay: displayCard)
            } else {
                self.displayCard()
            }
        } else {
            recipeLabel.text = "No cards to display"
        }
    }
    
    func displayQuestionOrAnswer(cardToDisplay card: Recipe) {
        switch currentDisplayMode {
        case .ingredientsFirst:
            recipeLabel.text = card.ingredient
        case .recipeFirst:
            recipeLabel.text = card.recipe
        }
    }
    
    @IBAction func swipeRightAction(_ sender: UISwipeGestureRecognizer) {
        displayCard()
    }
    
    @IBAction func swipeDownAction(_ sender: UISwipeGestureRecognizer) {
        if let card = currentCard {
            recipeLabel.text = card.recipe
        }
    }
    
    @IBAction func swipeUpAction(_ sender: UISwipeGestureRecognizer) {
        if let card = currentCard {
            recipeLabel.text = card.ingredient
        }
    }
    
    @IBAction func deleteCardAction(_ sender: UIButton) {
        if currentCard == nil {
            return
        } else {
            managedObjectContext.delete(currentCard!)
            
            do {
                try managedObjectContext.save()
                print("Recipe succesfully deleted")
                fetchCards()
                displayCard()
            } catch {
                print("ManagedObjectContext could not be saved, recipe could not be deleted")
            }
        }
    }
    
}

