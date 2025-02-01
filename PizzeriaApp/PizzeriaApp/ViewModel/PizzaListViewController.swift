

import UIKit

class PizzaListViewController: UITableViewController {
    
    var pizzas: [Pizza] = []
    var favoritePizzas: Set<String> = []
    private var favoritePizzerias: [Pizzeria] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lista de Pizzas"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PizzaCell")
        loadPizzaData()
    }
    
    func loadPizzaData() {
        if let url = Bundle.main.url(forResource: "pizza-info", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let pizzaInfo = try JSONDecoder().decode(PizzaInfo.self, from: data)
                self.pizzas = pizzaInfo.pizzas
                tableView.reloadData()
            } catch {
                print("Error al cargar el JSON: \(error)")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaCell", for: indexPath)
        let pizza = pizzas[indexPath.row]
        cell.textLabel?.text = pizza.name
        cell.accessoryType = favoritePizzas.contains(pizza.name) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pizza = pizzas[indexPath.row]
        let detailVC = PizzaDetailViewController(pizza: pizza)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let pizza = pizzas[indexPath.row]
        
        let favoriteAction = UITableViewRowAction(style: .normal, title:
                                                    favoritePizzas.contains(pizza.name) ? "Quitar" : "Favorito") { _, _ in
            if self.favoritePizzas.contains(pizza.name) {
                self.favoritePizzas.remove(pizza.name)
            } else {
                self.favoritePizzas.insert(pizza.name)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        favoriteAction.backgroundColor = favoritePizzas.contains(pizza.name) ? .red : .green
        
        return [favoriteAction]
    }
    
    private func saveFavoritePizzerias() {
        do {
            let data = try JSONEncoder().encode(favoritePizzerias)
            UserDefaults.standard.set(data, forKey: "favoritePizzaKey")
        } catch {
            print("Error al guardar pizzerías favoritas: \(error)")
        }
    }




}





