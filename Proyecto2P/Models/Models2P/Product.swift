import Foundation
import FirebaseFirestoreSwift

struct Product: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Descripcion:String
    var Unidad:Int
    var Costo:Float
    var Precio:Float
    var Utilidad:Float

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Descripcion
        case Unidad
        case Costo
        case Precio
        case Utilidad
    }
}
