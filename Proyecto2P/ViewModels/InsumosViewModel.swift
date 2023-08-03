import Foundation
import Firebase
import Combine
import FirebaseFirestore

class InsumosViewModel: ObservableObject {
    @Published var insumo: Insumos
    @Published var modified = false
    @Published var insumos: [Insumos] = []
    @Published var isEditing = false
    @Published var NombreInsumos: [String] = []
     
    private var cancellables = Set<AnyCancellable>()
     
    init(insumo: Insumos = Insumos(Nombre: "", Cantidad: 0, Precio: 0, Categoria: "")) {
      self.insumo = insumo
       
      self.$insumo
        .dropFirst()
        .sink { [weak self] insumo in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchInsumos()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo insumo
    private func addInsumo(_ insumo: Insumos) {
        do {
            let _ = try db.collection("InsumosList").addDocument(from: insumo) { error in
                if let error = error {
                    print("Error al agregar insumo:", error.localizedDescription)
                } else {
                    print("Insumo agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del insumo:", error.localizedDescription)
        }
    }
    
    // Actualizar un insumo
    private func updateInsumo(_ insumo: Insumos) {
      if let documentId = insumo.id {
        do {
          try db.collection("InsumosList").document(documentId).setData(from: insumo)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar insumo
    private func updateOrAddInsumo() {
      if let _ = insumo.id {
        self.updateInsumo(self.insumo)
      }
      else {
        addInsumo(insumo)
      }
    }
    
    // Eliminar insumo
    private func deleteInsumo(_ insumo: Insumos) {
      if let documentId = insumo.id {
        db.collection("InsumosList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchInsumos() // Actualizar la lista de usuarios después de eliminar
          }
        }
      }
    }

    
    func fetchInsumos() {
            db.collection("InsumosList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener insumos:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron insumos")
                    return
                }

                self.insumos = documents.compactMap { document in
                    do {
                        let insumo = try document.data(as: Insumos.self)
                        return insumo
                    } catch {
                        print("Error al obtener datos del insumo:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    func llenarComboBox(completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        let idInsumosRef = db.collection("InsumosList")

        idInsumosRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error al obtener los datos: \(error.localizedDescription)")
                completion([])
                return
            }
            
            for document in snapshot!.documents {
                if let nombre = document.data()["Nombre"] as? String {
                    self.NombreInsumos.append(nombre)
                }
            }
            
            completion(self.NombreInsumos)
        }
    }

    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddInsumo()
        fetchInsumos()
    }
    
    func handleDeleteTapped(insumo: Insumos) {
        self.deleteInsumo(insumo)
    }
}
