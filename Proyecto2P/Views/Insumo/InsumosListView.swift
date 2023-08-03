//
//  InsumosListView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 02/06/23.
//

import SwiftUI

struct InsumosListView: View {
    @ObservedObject var insumoManager = InsumosViewModel()
    @State private var insumosSeleccionado: Insumos?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("insumos")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("INSUMOS")
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
                    ForEach(insumoManager.insumos, id: \.id) { insumo in
                        NavigationLink(destination: InsumoView(insumo: insumo, mode: .edit)) {
                        HStack {
                            Image("insumoicon")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(insumo.Nombre)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text(insumo.Categoria)
                                    .font(.system(size: 14))
                                    .foregroundColor(CustomColor.drSimiBlue)
                            }
                            
                            Spacer()
                            
                        }
                        .swipeActions {
                            Button(action: {
                                insumosSeleccionado = insumo
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
                                    if let insumo = insumosSeleccionado {
                                        insumoManager.handleDeleteTapped(insumo: insumo)
                                        print("Insumo eliminado", insumo)
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
            .overlay(newInsumoButton, alignment: .bottom)
        }.background(Color.white)
    }
    
    private var newInsumoButton: some View {
        
        NavigationLink(destination: InsumoView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nuevo insumo")
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

struct InsumosListView_Previews: PreviewProvider {
    static var previews: some View {
        InsumosListView()
    }
}
