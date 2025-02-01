

import UIKit

class PizzeriaListViewController: UITableViewController {

    private var pizzerias: [Pizzeria] = []
    
    private var favoritePizzerias: [Pizzeria] = [] // Lista de favoritos completa
    private var favorites: Set<String> = [] // Solo los nombres de las pizzerías favoritas

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lista de Pizzerías"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadFavorites() // Cargar favoritos desde UserDefaults
        loadPizzerias()
        saveFavorites()
    }


    func loadPizzerias() {
        if let url = Bundle.main.url(forResource: "pizza-info", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let pizzaInfo = try JSONDecoder().decode(PizzaInfo.self, from: data)
                self.pizzerias = pizzaInfo.pizzerias
                tableView.reloadData()
            } catch {
                print("Error al cargar el JSON: \(error)")
            }
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "favorites") else { return }
        do {
            let savedFavorites = try JSONDecoder().decode([String].self, from: data)
            favorites = Set(savedFavorites)
        } catch {
            print("Error al cargar favoritos: \(error)")
        }
    }


    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzerias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pizzeria = pizzerias[indexPath.row]
        cell.textLabel?.text = pizzeria.name
        cell.accessoryType = favorites.contains(pizzeria.name) ? .checkmark : .none
        return cell
    }

    // MARK: - TableView Swipe Actions

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pizzeria = pizzerias[indexPath.row]
        let favoriteAction = UIContextualAction(style: .normal, title: favorites.contains(pizzeria.name) ? "Remove" : "Favorite") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            if self.favorites.contains(pizzeria.name) {
                self.favorites.remove(pizzeria.name)
            } else {
                self.favorites.insert(pizzeria.name)
            }
            self.saveFavorites() // Guardar los favoritos
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        favoriteAction.backgroundColor = favorites.contains(pizzeria.name) ? .red : .green

        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }

    // MARK: - TableView Selection

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pizzeria = pizzerias[indexPath.row]
        let detailVC = PizzeriaDetailViewController(pizzeria: pizzeria)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favoritePizzerias) // Guardar como array de objetos
            UserDefaults.standard.set(data, forKey: "favorites")
        } catch {
            print("Error al guardar favoritos: \(error)")
        }
    }

}

