import Foundation
import Firebase
import Combine
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var modified = false
    @Published var users: [User] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(user: User = User(Nombre: "", Apellido: "", Edad: 0, Genero: "", Correo: "", Contraseña: "")) {
      self.user = user
       
      self.$user
        .dropFirst()
        .sink { [weak self] user in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchUsers()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo usuario
    private func addUser(_ user: User) {
        do {
            let _ = try db.collection("UserList").addDocument(from: user) { error in
                if let error = error {
                    print("Error al agregar usuario:", error.localizedDescription)
                } else {
                    print("Usuario agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del usuario:", error.localizedDescription)
        }
    }
    
    // Actualizar un usuario
    private func updateUser(_ user: User) {
      if let documentId = user.id {
        do {
          try db.collection("UserList").document(documentId).setData(from: user)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar usuario
    private func updateOrAddUser() {
      if let _ = user.id {
        self.updateUser(self.user)
      }
      else {
        addUser(user)
      }
    }
    
    // Eliminar usuario
    private func deleteUser(_ user: User) {
      if let documentId = user.id {
        db.collection("UserList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchUsers() // Actualizar la lista de usuarios después de eliminar
          }
        }
      }
    }

    
    func fetchUsers() {
            db.collection("UserList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener usuarios:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron usuarios")
                    return
                }

                self.users = documents.compactMap { document in
                    do {
                        let user = try document.data(as: User.self)
                        return user
                    } catch {
                        print("Error al obtener datos del usuario:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddUser()
        fetchUsers() 
    }
    
    func handleDeleteTapped(user: User) {
        self.deleteUser(user)
    }
}
