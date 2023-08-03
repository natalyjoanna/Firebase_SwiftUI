//
//  SalesView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 24/04/23.
//

import SwiftUI

struct SalesView: View {
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    @ObservedObject var saleManager = SaleViewModel()
    var mode: Mode?
    
    init(sale: Sale? = nil, mode: Mode?) {
        saleManager = SaleViewModel(sale: sale ?? Sale(Nombre: "", Cantidad: 0, IDVendedor: 0, IDComprador: 0, Piezas: 0, Subtotal: 0, Total: 0))
        print("Ventas recibido:", saleManager.sale)
        self.mode = mode
        
    }
    
    var body: some View {
            
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Nueva Venta" : saleManager.sale.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                    
                    Image("salesicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $saleManager.sale.Nombre, title: "Nombre", placeholder: "Ingrese el nombre de la venta")
                        InputView(text: Binding<String>(
                                get: { String(saleManager.sale.Cantidad) },
                                set: { if let value = Int($0) { saleManager.sale.Cantidad = value } }
                                ), title: "Cantidad", placeholder: "Ingrese la cantidad")
                        InputView(text: Binding<String>(
                                get: { String(saleManager.sale.IDVendedor) },
                                set: { if let value = Int($0) { saleManager.sale.IDVendedor = value } }
                                ), title: "ID Vendedor", placeholder: "Ingrese el id del vendedor")
                        InputView(text: Binding<String>(
                                get: { String(saleManager.sale.IDComprador) },
                                set: { if let value = Int($0) { saleManager.sale.IDComprador = value } }
                                ), title: "ID Comprador", placeholder: "Ingrese el id del comprador")
                        InputView(text: Binding<String>(
                                get: { String(saleManager.sale.Piezas) },
                                set: { if let value = Float($0) { saleManager.sale.Piezas = value } }
                                ), title: "Precio", placeholder: "Ingrese el precio")
                        InputView(text: Binding<String>(
                                get: { String(saleManager.sale.Subtotal) },
                                set: { if let value = Float($0) { saleManager.sale.Subtotal = value } }
                                ), title: "Subtotal", placeholder: "Ingrese el subtotal")
                        InputView(text: Binding<String>(
                                get: { String(saleManager.sale.Total) },
                                set: { if let value = Float($0) { saleManager.sale.Total = value } }
                                ), title: "Total", placeholder: "Ingrese el total")
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        saleManager.handleDoneTapped()
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
                              message: Text(mode == .new ? "La venta se ha registrado correctamente" : "La venta se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: SaleListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de ventas")
                            
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
    


struct SalesView_Previews: PreviewProvider {
    static var previews: some View {
        SalesView(mode: .new)
    }
}
