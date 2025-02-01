
import UIKit

class IngredientsViewController: UITableViewController {

    private var ingredients: [String] = [] // Lista de ingredientes
    private var selectedIngredients: Set<String> = [] // Ingredientes seleccionados
    private var customPizzas: [Pizza] = [] // Lista de pizzas personalizadas


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ingredientes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadIngredients()

        // Agregar botón para crear pizza
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Crear Pizza", style: .done, target: self, action: #selector(createPizza))
    }

    private func loadIngredients() {
        if let url = Bundle.main.url(forResource: "pizza-info", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let pizzaInfo = try JSONDecoder().decode(PizzaInfo.self, from: data)
                self.ingredients = pizzaInfo.ingredients
                tableView.reloadData()
            } catch {
                print("Error al cargar el JSON: \(error)")
            }
        }
    }

    @objc private func createPizza() {
        guard !selectedIngredients.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Selecciona al menos un ingrediente", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let alert = UIAlertController(title: "Nueva Pizza", message: "Ingresa el nombre de tu pizza", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nombre de la pizza"
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let pizzaName = alert.textFields?.first?.text, !pizzaName.isEmpty {
                // Crear una nueva pizza
                let newPizza = Pizza(name: pizzaName, ingredients: Array(self.selectedIngredients))
                self.customPizzas.append(newPizza)
                print("Pizza creada: \(newPizza)")
                self.selectedIngredients.removeAll() // Deseleccionar ingredientes
                self.tableView.reloadData()
            }
        }

        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let ingredient = ingredients[indexPath.row]
        cell.textLabel?.text = ingredient
        cell.accessoryType = selectedIngredients.contains(ingredient) ? .checkmark : .none
        return cell
    }

    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    struct CustomPizza: Codable {
        let name: String
        let ingredients: [String]
    }
}




