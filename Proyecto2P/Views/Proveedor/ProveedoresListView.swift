//
//  ProveedoresListView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 02/06/23.
//

import SwiftUI

struct ProveedoresListView: View {
    @ObservedObject var proveedorManager = ProveedorViewModel()
    @State private var proveedorSeleccionado: Proveedor?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("proveedoricon")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("PROVEEDORES")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.black)
            }
        }
    }
    
    var body: some View {
        ZStack{
            
            VStack {
                navBar
                
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(CustomColor.drSimiBlue)
                    .padding(.horizontal, 20)
                
                List {
                    ForEach(proveedorManager.proveedores, id: \.id) { proveedor in
                        NavigationLink(destination: ProveedorView(proveedor: proveedor, mode: .edit)) {
                        HStack {
                            Image("proveedor")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(proveedor.Nombre)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text(proveedor.Correo)
                                    .font(.system(size: 14))
                                    .foregroundColor(CustomColor.drSimiBlue)
                            }
                            
                            Spacer()
                            
                        }
                        .swipeActions {
                            Button(action: {
                                proveedorSeleccionado = proveedor
                                mostrarAlerta = true
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $mostrarAlerta) {
                            Alert(
                                title: Text("Eliminar Proveedor"),
                                message: Text("¿Estás seguro de que quieres eliminar este proveedor?"),
                                primaryButton: .destructive(Text("Eliminar"), action: {
                                    if let proveedor = proveedorSeleccionado {
                                        proveedorManager.handleDeleteTapped(proveedor: proveedor)
                                        print("Proveedor eliminado", proveedor)
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
            .overlay(newProveedorButton, alignment: .bottom)
        }.background(Color.white)
    }
    
    private var newProveedorButton: some View {
        
        NavigationLink(destination: ProveedorView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nuevo Proveedor")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(CustomColor.drSimiBlue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
            }
    }
}

struct ProveedoresListView_Previews: PreviewProvider {
    static var previews: some View {
        ProveedoresListView()
    }
}
