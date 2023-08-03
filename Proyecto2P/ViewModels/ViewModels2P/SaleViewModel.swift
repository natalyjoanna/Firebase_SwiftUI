import Foundation
import Firebase
import Combine
import FirebaseFirestore

class SaleViewModel: ObservableObject {
    @Published var sale: Sale
    @Published var modified = false
    @Published var sales: [Sale] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(sale: Sale = Sale(Nombre: "", Cantidad: 0, IDVendedor: 0, IDComprador: 0, Piezas: 0, Subtotal: 0, Total: 0)) {
      self.sale = sale
       
      self.$sale
        .dropFirst()
        .sink { [weak self] sale in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchSales()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo venta
    private func addSale(_ sale: Sale) {
        do {
            let _ = try db.collection("SalesList").addDocument(from: sale) { error in
                if let error = error {
                    print("Error al agregar venta:", error.localizedDescription)
                } else {
                    print("Venta agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del venta:", error.localizedDescription)
        }
    }
    
    // Actualizar un venta
    private func updateSale(_ sale: Sale) {
      if let documentId = sale.id {
        do {
          try db.collection("SalesList").document(documentId).setData(from: sale)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar venta
    private func updateOrAddSale() {
      if let _ = sale.id {
        self.updateSale(self.sale)
      }
      else {
        addSale(sale)
      }
    }
    
    // Eliminar venta
    private func deleteSale(_ sale: Sale) {
      if let documentId = sale.id {
        db.collection("SalesList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchSales() // Actualizar la lista de ventas después de eliminar
          }
        }
      }
    }

    
    func fetchSales() {
            db.collection("SalesList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener usuarios:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron usuarios")
                    return
                }

                self.sales = documents.compactMap { document in
                    do {
                        let sale = try document.data(as: Sale.self)
                        return sale
                    } catch {
                        print("Error al obtener datos del venta:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddSale()
        fetchSales()
    }
    
    func handleDeleteTapped(sale: Sale) {
        self.deleteSale(sale)
    }
}
