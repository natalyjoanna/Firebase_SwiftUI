import Foundation
import FirebaseFirestoreSwift

struct Cliente: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Apellido:String
    var Edad:Int
    var Telefono:String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Apellido
        case Edad
        case Telefono
    }
}
