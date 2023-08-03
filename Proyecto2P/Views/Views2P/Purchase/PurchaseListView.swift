//
//  PurchaseListView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 19/05/23.
//

import SwiftUI

struct PurchaseListView: View {
    @ObservedObject var purchaseManager = PurchaseViewModel()
    @State private var compraSeleccionada: Purchase?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("purchaseicon")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("COMPRAS")
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }
    
    var body: some View {
        
            ZStack{
                
                LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                
                VStack {
                    navBar
                    
                    List {
                        ForEach(purchaseManager.purchases, id: \.id) { purchase in
                            NavigationLink(destination: PurchaseView(purchase: purchase, mode: .edit)) {
                            HStack {
                                Image("purchaseicon")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.system(size: 32))
                                    .frame(width: 40, height: 40)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(purchase.Nombre)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(String(purchase.Piezas))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.purple))
                                }
                                
                                Spacer()
                            }
                            .swipeActions {
                                Button(action: {
                                    compraSeleccionada = purchase
                                    mostrarAlerta = true
                                }) {
                                    Label("Eliminar", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                            .alert(isPresented: $mostrarAlerta) {
                                Alert(
                                    title: Text("Eliminar Compra"),
                                    message: Text("¿Estás seguro de que quieres eliminar esta compra?"),
                                    primaryButton: .destructive(Text("Eliminar"), action: {
                                        if let compra = compraSeleccionada {
                                            purchaseManager.handleDeleteTapped(purchase: purchase)
                                            print("Compra eliminada", compra)
                                        }
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                        .listRowBackground(Color.clear)
                            
                        }
                        
                    }
                    .listStyle(.plain)
                    .padding(.bottom, 50)
                    
                }
                .overlay(newPurchaseButton, alignment: .bottom)
            }
    }
    
    private var newPurchaseButton: some View {
        
        NavigationLink(destination: PurchaseView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nueva compra")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color(.purple))
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
            }
    }
    
}

struct PurchaseListView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseListView()
    }
}
