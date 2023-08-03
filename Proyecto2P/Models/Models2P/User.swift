import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Apellido:String
    var Edad:Int
    var Genero:String
    var Correo:String
    var Contraseña:String

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Apellido
        case Edad
        case Genero
        case Correo
        case Contraseña
    }
}
