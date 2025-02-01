

import Foundation

struct Pizza: Codable {
    let name: String
    let ingredients: [String]
}

struct Pizzeria: Codable {
    let name: String
    let address: String
    let coordinates: Coordinates?
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

struct PizzaInfo: Codable {
    let pizzerias: [Pizzeria]
    let pizzas: [Pizza]
    let ingredients: [String]
}







