

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    private let coordinates: Coordinates
    private let pizzeriaName: String
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?

    init(coordinates: Coordinates, pizzeriaName: String) {
        self.coordinates = coordinates
        self.pizzeriaName = pizzeriaName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Configuración del mapa
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Botón de cerrar
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cerrar", for: .normal)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Configuración del mapa
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        mapView.setRegion(region, animated: true)

        // Agregar pin para la pizzería
        let pizzeriaPin = MKPointAnnotation()
        pizzeriaPin.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        pizzeriaPin.title = pizzeriaName
        mapView.addAnnotation(pizzeriaPin)

        // Configurar ubicación del usuario
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Botón para obtener direcciones
        let directionsButton = UIButton(type: .system)
        directionsButton.setTitle("Obtener Direcciones", for: .normal)
        directionsButton.addTarget(self, action: #selector(showDirections), for: .touchUpInside)
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(directionsButton)

        NSLayoutConstraint.activate([
            directionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            directionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func showDirections() {
        guard let userLocation = userLocation else {
            print("No se pudo obtener la ubicación del usuario.")
            return
        }

        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let pizzeriaPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: pizzeriaPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
            print("Error al calcular la ruta: \(error?.localizedDescription ?? "Desconocido")")


            return
            }

            let mapView = self.view.subviews.compactMap { $0 as? MKMapView }.first
            mapView?.addOverlay(route.polyline)
            mapView?.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4
        return renderer
    }
}
