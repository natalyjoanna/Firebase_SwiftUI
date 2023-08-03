import Foundation
import FirebaseFirestoreSwift

struct Empleado: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Apellido:String
    var Turno:String
    var Correo:String
    var Contraseña:String
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Apellido
        case Turno
        case Correo
        case Contraseña
    }
}

