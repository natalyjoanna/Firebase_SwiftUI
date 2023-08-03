import Foundation
import FirebaseFirestoreSwift

struct Purchase: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Piezas:Float
    var IDAdministrador:Int

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Piezas
        case IDAdministrador
    }
}
