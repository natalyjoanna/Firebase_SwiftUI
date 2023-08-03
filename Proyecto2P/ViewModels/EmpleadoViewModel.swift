import Foundation
import Firebase
import Combine
import FirebaseFirestore

class EmpleadoViewModel: ObservableObject {
    @Published var empleado: Empleado
    @Published var modified = false
    @Published var empleados: [Empleado] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(empleado: Empleado = Empleado(Nombre: "", Apellido: "", Turno: "", Correo: "", Contraseña: "")) {
      self.empleado = empleado
       
      self.$empleado
        .dropFirst()
        .sink { [weak self] empleado in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchEmpleados()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo empleado
    private func addEmpleado(_ empleado: Empleado) {
        do {
            let _ = try db.collection("EmpleadoList").addDocument(from: empleado) { error in
                if let error = error {
                    print("Error al agregar empleado:", error.localizedDescription)
                } else {
                    print("Empleado agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del empleado:", error.localizedDescription)
        }
    }
    
    // Actualizar un empleado
    private func updateEmpleado(_ empleado: Empleado) {
      if let documentId = empleado.id {
        do {
          try db.collection("EmpleadoList").document(documentId).setData(from: empleado)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar empleado
    private func updateOrAddEmpleado() {
      if let _ = empleado.id {
        self.updateEmpleado(self.empleado)
      }
      else {
        addEmpleado(empleado)
      }
    }
    
    // Eliminar empleado
    private func deleteEmpleado(_ empleado: Empleado) {
      if let documentId = empleado.id {
        db.collection("EmpleadoList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchEmpleados() // Actualizar la lista de empleados después de eliminar
          }
        }
      }
    }

    
    func fetchEmpleados() {
            db.collection("EmpleadoList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener empleados:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron empleados")
                    return
                }

                self.empleados = documents.compactMap { document in
                    do {
                        let empleado = try document.data(as: Empleado.self)
                        return empleado
                    } catch {
                        print("Error al obtener datos del empleado:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddEmpleado()
        fetchEmpleados()
    }
    
    func handleDeleteTapped(empleado: Empleado) {
        self.deleteEmpleado(empleado)
    }
}
