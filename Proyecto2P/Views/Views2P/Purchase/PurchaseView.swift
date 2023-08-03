//
//  PurchaseView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 24/04/23.
//

import SwiftUI

struct PurchaseView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    
    @ObservedObject var purchaseManager = PurchaseViewModel()
    var mode: Mode?
    
    init(purchase: Purchase? = nil, mode: Mode?) {
        purchaseManager = PurchaseViewModel(purchase: purchase ?? Purchase(Nombre: "", Piezas: 0, IDAdministrador: 0))
        //print("Purchase recibido:", purchaseManager.purchase)
        self.mode = mode
        
    }
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Nueva Compra" : purchaseManager.purchase.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                    
                    Image("purchaseicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $purchaseManager.purchase.Nombre, title: "Nombre", placeholder: "Ingrese el nombre de la compra")
                        InputView(text: Binding<String>(
                                get: { String(purchaseManager.purchase.Piezas) },
                                set: { if let value = Float($0) { purchaseManager.purchase.Piezas = value } }
                                ), title: "Precio", placeholder: "Ingrese el precio")
                        InputView(text: Binding<String>(
                                get: { String(purchaseManager.purchase.IDAdministrador) },
                                set: { if let value = Int($0) { purchaseManager.purchase.IDAdministrador = value } }
                                ), title: "ID Admin", placeholder: "Ingrese el Id del administrador")
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        purchaseManager.handleDoneTapped()
                        mostrarAlerta = true
                    } label: {
                        HStack {
                            Text(mode == .new ? "REGISTRAR" : "ACTUALIZAR")
                                    .fontWeight(.semibold)
                        }
                        .foregroundColor(Color(.white))
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.purple))
                    .cornerRadius(10)
                    .padding(.top, 24)
                    .alert(isPresented: $mostrarAlerta) {
                        Alert(title: Text(mode == .new ? "Registro Exitoso" : "Actualizacion Exitosa"),
                              message: Text(mode == .new ? "La compra se ha registrado correctamente" : "La compra se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: PurchaseListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de compras")
                            
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemPurple))
                    })
                }
                
            }
        }
    }
}


struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(mode: .new)
    }
}
