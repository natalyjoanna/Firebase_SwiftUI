import Foundation
import Firebase
import Combine
import FirebaseFirestore

class ProductViewModel: ObservableObject {
    @Published var product: Product
    @Published var modified = false
    @Published var products: [Product] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(product: Product = Product(Nombre: "", Descripcion: "", Unidad: 0, Costo: 0.0, Precio: 0.0, Utilidad: 0.0)) {
      self.product = product
       
      self.$product
        .dropFirst()
        .sink { [weak self] product in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchProducts()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo usuario
    private func addProduct(_ product: Product) {
        do {
            let _ = try db.collection("ProductList").addDocument(from: product) { error in
                if let error = error {
                    print("Error al agregar producto:", error.localizedDescription)
                } else {
                    print("Producto agregado exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos del producto:", error.localizedDescription)
        }
    }
    
    // Actualizar un usuario
    private func updateProduct(_ product: Product) {
      if let documentId = product.id {
        do {
          try db.collection("ProductList").document(documentId).setData(from: product)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar producto
    private func updateOrAddProduct() {
      if let _ = product.id {
        self.updateProduct(self.product)
      }
      else {
        addProduct(product)
      }
    }
    
    // Eliminar producto
    private func deleteProduct(_ product: Product) {
      if let documentId = product.id {
        db.collection("ProductList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchProducts() // Actualizar la lista de productos después de eliminar
          }
        }
      }
    }

    // Mostrar productos
    func fetchProducts() {
            db.collection("ProductList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener productos:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron productos")
                    return
                }

                self.products = documents.compactMap { document in
                    do {
                        let product = try document.data(as: Product.self)
                        return product
                    } catch {
                        print("Error al obtener datos del producto:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddProduct()
        fetchProducts()
    }
    
    func handleDeleteTapped(product: Product) {
        self.deleteProduct(product)
    }
}
