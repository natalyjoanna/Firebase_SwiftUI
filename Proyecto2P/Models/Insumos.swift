import Foundation
import FirebaseFirestoreSwift

struct Insumos: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Cantidad:Int
    var Precio:Float
    var Categoria:String

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Cantidad
        case Precio
        case Categoria
    }
}

