/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import ArgoKit
import CoreLocation

class Landmark: Hashable, Codable, ArgoKitIdentifiable {
    static func == (lhs: Landmark, rhs: Landmark) -> Bool {
        if lhs.identifier == rhs.identifier
            && lhs.reuseIdentifier == rhs.reuseIdentifier {
            return true
        }
        return false
    }
    
    var identifier : String
    var reuseIdentifier: String
    var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    var state: String
    var park: String
    var category: Category

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
    }
    

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(reuseIdentifier)
    }
}

extension Landmark {
    var image: ImageView {
        ImageStore.shared.image(name: imageName)
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
