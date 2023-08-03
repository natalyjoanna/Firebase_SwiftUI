import Foundation
import Firebase
import Combine
import FirebaseFirestore

class ProveedorViewModel: ObservableObject {
    @Published var proveedor: Proveedor
    @Published var modified = false
    @Published var proveedores: [Proveedor] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(proveedor: Proveedor = Proveedor(Nombre: "", Correo: "", idInsumo: "", Telefono: "")) {
      self.proveedor = proveedor
       
      self.$proveedor
        .dropFirst()
        .sink { [weak self] proveedor in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchProveedores()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo proveedor
    private func addProveedor(_ proveedor: Proveedor) {
        do {
            let _ = try db.collection("ProveedorList").addDocument(from: proveedor) { error in
                if let error = error {
                    print("Error al agregar proveedor:", error.localizedDescription)
                } else {
                    print("Proveedor agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del proveedor:", error.localizedDescription)
        }
    }
    
    // Actualizar un proveedor
    private func updateProveedor(_ proveedor: Proveedor) {
      if let documentId = proveedor.id {
        do {
          try db.collection("ProveedorList").document(documentId).setData(from: proveedor)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar proveedor
    private func updateOrAddProveedor() {
      if let _ = proveedor.id {
        self.updateProveedor(self.proveedor)
      }
      else {
        addProveedor(proveedor)
      }
    }
    
    // Eliminar proveedor
    private func deleteProveedor(_ proveedor: Proveedor) {
      if let documentId = proveedor.id {
        db.collection("ProveedorList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchProveedores() // Actualizar la lista de usuarios después de eliminar
          }
        }
      }
    }

    
    func fetchProveedores() {
            db.collection("ProveedorList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener proveedores:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron proveedores")
                    return
                }

                self.proveedores = documents.compactMap { document in
                    do {
                        let proveedor = try document.data(as: Proveedor.self)
                        return proveedor
                    } catch {
                        print("Error al obtener datos del proveedor:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddProveedor()
        fetchProveedores()
    }
    
    func handleDeleteTapped(proveedor: Proveedor) {
        self.deleteProveedor(proveedor)
    }
}
