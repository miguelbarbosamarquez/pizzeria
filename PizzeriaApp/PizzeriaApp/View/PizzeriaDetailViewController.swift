

import UIKit

class PizzeriaDetailViewController: UIViewController {

    private let pizzeria: Pizzeria

    // Inicializador que recibe la pizzería seleccionada
    init(pizzeria: Pizzeria) {
        self.pizzeria = pizzeria
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = pizzeria.name

        setupUI()
    }

    private func setupUI() {
        // Etiqueta para mostrar la dirección
        let addressLabel = UILabel()
        addressLabel.text = "Dirección: \(pizzeria.address)"
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        // Botón para abrir el mapa
        let mapButton = UIButton(type: .system)
        mapButton.setTitle("Ver en el mapa", for: .normal)
        mapButton.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.isHidden = (pizzeria.coordinates == nil) // Solo mostrar si tiene coordenadas

        // Contenedor vertical
        let stackView = UIStackView(arrangedSubviews: [addressLabel, mapButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Añadir a la vista principal
        view.addSubview(stackView)

        // Configurar las restricciones
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func showMap() {
        guard let coordinates = pizzeria.coordinates else { return }
        let mapVC = MapViewController(coordinates: coordinates, pizzeriaName: pizzeria.name)
        navigationController?.pushViewController(mapVC, animated: true)
    }
}

