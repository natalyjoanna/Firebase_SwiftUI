import Foundation
import FirebaseFirestoreSwift

struct Proveedor: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Correo:String
    var idInsumo:String
    var Telefono:String

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Correo
        case idInsumo
        case Telefono
    }
}

