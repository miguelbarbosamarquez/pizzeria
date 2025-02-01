
import UIKit

class NavigationTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers(){
        let pizzaListViewController = UINavigationController(rootViewController:
        PizzaListViewController())
        pizzaListViewController.tabBarItem.title = "Pizzas"
        pizzaListViewController.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        let pizzeriaListViewController = UINavigationController(rootViewController:
        PizzeriaListViewController())
        pizzeriaListViewController.tabBarItem.title = "Pizzería"
        pizzeriaListViewController.tabBarItem.image = UIImage(systemName: "house")
        
        let favoritesTableViewController = UINavigationController(rootViewController:
        FavoritesViewController())
        favoritesTableViewController.tabBarItem.title = "Favorites"
        favoritesTableViewController.tabBarItem.image = UIImage(systemName: "heart")
        
        let ingredientsTableViewController = UINavigationController(rootViewController: IngredientsViewController())
        ingredientsTableViewController.tabBarItem.title = "Ingredients"
        ingredientsTableViewController.tabBarItem.image = UIImage(systemName: "leaf")
        
        viewControllers = [pizzaListViewController, pizzeriaListViewController, favoritesTableViewController, ingredientsTableViewController]
    }

}
