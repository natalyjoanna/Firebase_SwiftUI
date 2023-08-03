import Foundation
import Firebase
import Combine
import FirebaseFirestore

class ClienteViewModel: ObservableObject {
    @Published var cliente: Cliente
    @Published var modified = false
    @Published var clientes: [Cliente] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(cliente: Cliente = Cliente(Nombre: "", Apellido: "", Edad: 0, Telefono: "")) {
      self.cliente = cliente
       
      self.$cliente
        .dropFirst()
        .sink { [weak self] cliente in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchClientes()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo cliente
    private func addCliente(_ cliente: Cliente) {
        do {
            let _ = try db.collection("ClienteList").addDocument(from: cliente) { error in
                if let error = error {
                    print("Error al agregar cliente:", error.localizedDescription)
                } else {
                    print("Cliente agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del cliente:", error.localizedDescription)
        }
    }
    
    // Actualizar un cliente
    private func updateCliente(_ cliente: Cliente) {
      if let documentId = cliente.id {
        do {
          try db.collection("ClienteList").document(documentId).setData(from: cliente)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar cliente
    private func updateOrAddCliente() {
      if let _ = cliente.id {
        self.updateCliente(self.cliente)
      }
      else {
        addCliente(cliente)
      }
    }
    
    // Eliminar cliente
    private func deleteCliente(_ cliente: Cliente) {
      if let documentId = cliente.id {
        db.collection("ClienteList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchClientes() // Actualizar la lista de usuarios después de eliminar
          }
        }
      }
    }

    
    func fetchClientes() {
            db.collection("ClienteList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener clientes:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron clientes")
                    return
                }

                self.clientes = documents.compactMap { document in
                    do {
                        let cliente = try document.data(as: Cliente.self)
                        return cliente
                    } catch {
                        print("Error al obtener datos del cliente:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddCliente()
        fetchClientes()
    }
    
    func handleDeleteTapped(cliente: Cliente) {
        self.deleteCliente(cliente)
    }
}
