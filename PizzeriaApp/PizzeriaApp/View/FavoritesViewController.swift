
import UIKit

class FavoritesViewController: UITableViewController {

    private var favoritePizzerias: [Pizzeria] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadFavoritePizzerias()
        tableView.reloadData()
    }

    private func loadFavoritePizzerias() {
        guard let data = UserDefaults.standard.data(forKey: "favorites") else {
            favoritePizzerias = []
            return
        }

        do {
            favoritePizzerias = try JSONDecoder().decode([Pizzeria].self, from: data)
        } catch {
            print("Error al cargar pizzerías favoritas: \(error)")
            favoritePizzerias = []
        }
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePizzerias.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pizzeria = favoritePizzerias[indexPath.row]
        cell.textLabel?.text = pizzeria.name
        return cell
    }

    // MARK: - TableView Selection

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pizzeria = favoritePizzerias[indexPath.row]
        let detailVC = PizzeriaDetailViewController(pizzeria: pizzeria)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
