import Foundation
import FirebaseFirestoreSwift

struct Sale: Identifiable, Codable {
    
    @DocumentID var id:String?
    var Nombre:String
    var Cantidad:Int
    var IDVendedor:Int
    var IDComprador:Int
    var Piezas:Float
    var Subtotal:Float
    var Total:Float

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case Nombre
        case Cantidad
        case IDVendedor
        case IDComprador
        case Piezas
        case Subtotal
        case Total
    }
}
