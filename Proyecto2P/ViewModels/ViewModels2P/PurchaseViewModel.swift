//
//  PurchaseViewModel.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 19/05/23.
//

import Foundation
import Firebase
import Combine
import FirebaseFirestore

class PurchaseViewModel: ObservableObject {
    @Published var purchase: Purchase
    @Published var modified = false
    @Published var purchases: [Purchase] = []
    @Published var isEditing = false
     
    private var cancellables = Set<AnyCancellable>()
     
    init(purchase: Purchase = Purchase(Nombre: "", Piezas: 0, IDAdministrador: 0)) {
      self.purchase = purchase
       
      self.$purchase
        .dropFirst()
        .sink { [weak self] purchase in
          self?.modified = true
        }
        .store(in: &self.cancellables)
        
        fetchPurchase()

    }
    
    // Firestore
     
    private var db = Firestore.firestore()
     
    // Agregar nuevo usuario
    private func addPurchase(_ purchase: Purchase) {
        do {
            let _ = try db.collection("PurchaseList").addDocument(from: purchase) { error in
                if let error = error {
                    print("Error al agregar la compra:", error.localizedDescription)
                } else {
                    print("Compra agregada exitosamente")
                }
            }
        } catch {
            print("Error al serializar datos de la compra:", error.localizedDescription)
        }
    }
    
    // Actualizar un usuario
    private func updatePurchase(_ purchase: Purchase) {
      if let documentId = purchase.id {
        do {
          try db.collection("PurchaseList").document(documentId).setData(from: purchase)
            
        }
        catch {
          print(error)
        }
      }
    }
    
    // Agregar o actualizar producto
    private func updateOrAddPurchase() {
      if let _ = purchase.id {
        self.updatePurchase(self.purchase)
      }
      else {
        addPurchase(purchase)
      }
    }
    
    // Eliminar producto
    private func deletePurchase(_ purchase: Purchase) {
      if let documentId = purchase.id {
        db.collection("PurchaseList").document(documentId).delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.fetchPurchase() // Actualizar la lista de productos después de eliminar
          }
        }
      }
    }

    // Mostrar productos
    func fetchPurchase() {
            db.collection("PurchaseList").getDocuments { snapshot, error in
                if let error = error {
                    print("Error al obtener las compras:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron compras")
                    return
                }

                self.purchases = documents.compactMap { document in
                    do {
                        let purchase = try document.data(as: Purchase.self)
                        return purchase
                    } catch {
                        print("Error al obtener datos de la compra:", error.localizedDescription)
                        return nil
                    }
                }
            }
        }
    
    
    
    func handleDoneTapped() {
        print("Botón de registro presionado")
        updateOrAddPurchase()
        fetchPurchase()
    }
    
    func handleDeleteTapped(purchase: Purchase) {
        self.deletePurchase(purchase)
    }
}
