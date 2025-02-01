
import Foundation

class PizzaDataManager {
    static func loadPizzas() -> [Pizza] {
        guard let url = Bundle.main.url(forResource: "pizza-info", withExtension: "json") else {
            print("Error: No se encontró el archivo pizzas.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([String: [Pizza]].self, from: data)
            return decodedData["pizzas"] ?? []
        } catch {
            print("Error cargando pizzas.json: \(error)")
            return []
        }
    }
}




