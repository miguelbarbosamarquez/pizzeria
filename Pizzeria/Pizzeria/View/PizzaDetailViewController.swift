

import UIKit

class PizzaDetailViewController: UIViewController {
    
    var pizza: Pizza
    
    init(pizza: Pizza) {
        self.pizza = pizza
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = pizza.name
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredientes:"
        ingredientsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientsList = UITextView()
        ingredientsList.text = pizza.ingredients.joined(separator: "\n")
        ingredientsList.font = UIFont.systemFont(ofSize: 16)
        ingredientsList.isEditable = false
        ingredientsList.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(ingredientsLabel)
        view.addSubview(ingredientsList)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            ingredientsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            ingredientsList.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 10),
            ingredientsList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ingredientsList.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
}




