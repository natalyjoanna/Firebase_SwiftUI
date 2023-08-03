//
//  ListClienteView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 02/06/23.
//

import SwiftUI

struct ListClienteView: View {
    @ObservedObject var clienteManager = ClienteViewModel()
    @State private var clientesSeleccionado: Cliente?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("clientes")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("CLIENTES")
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
                    ForEach(clienteManager.clientes, id: \.id) { cliente in
                        NavigationLink(destination: ClienteView(cliente: cliente, mode: .edit)) {
                        HStack {
                            Image("cliente")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(cliente.Nombre)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text(cliente.Apellido)
                                    .font(.system(size: 14))
                                    .foregroundColor(CustomColor.drSimiBlue)
                            }
                            
                            Spacer()
                            
                        }
                        .swipeActions {
                            Button(action: {
                                clientesSeleccionado = cliente
                                mostrarAlerta = true
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $mostrarAlerta) {
                            Alert(
                                title: Text("Eliminar Usuario"),
                                message: Text("¿Estás seguro de que quieres eliminar este usuario?"),
                                primaryButton: .destructive(Text("Eliminar"), action: {
                                    if let cliente = clientesSeleccionado {
                                        clienteManager.handleDeleteTapped(cliente: cliente)
                                        print("Cliente eliminado", cliente)
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
            .overlay(newClienteButton, alignment: .bottom)
            
        }.background(Color.white)
        
        
    }
    
    private var newClienteButton: some View {
        
        NavigationLink(destination: ClienteView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nuevo Cliente")
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

struct ListClienteView_Previews: PreviewProvider {
    static var previews: some View {
        ListClienteView()
    }
}
