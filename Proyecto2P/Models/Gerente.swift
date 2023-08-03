import Foundation
import FirebaseFirestoreSwift

struct Gerente: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Apellido:String
    var Correo:String
    var Contraseña:String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Apellido
        case Correo
        case Contraseña
    }
}
