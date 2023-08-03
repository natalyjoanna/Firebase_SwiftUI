//
//  EmpleadoListView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 02/06/23.
//

import SwiftUI

struct EmpleadoListView: View {
    @ObservedObject var empleadoManager = EmpleadoViewModel()
    @State private var empleadosSeleccionado: Empleado?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("empleadosicon")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("EMPLEADOS")
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
                    ForEach(empleadoManager.empleados, id: \.id) { empleado in
                        NavigationLink(destination: EmpleadoView(empleado: empleado, mode: .edit)) {
                        HStack {
                            Image("empleado")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(empleado.Nombre)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.black)
                                Text(empleado.Apellido)
                                    .font(.system(size: 14))
                                    .foregroundColor(CustomColor.drSimiBlue)
                            }
                            
                            Spacer()
                            
                        }
                        .swipeActions {
                            Button(action: {
                                empleadosSeleccionado = empleado
                                mostrarAlerta = true
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $mostrarAlerta) {
                            Alert(
                                title: Text("Eliminar Empleado"),
                                message: Text("¿Estás seguro de que quieres eliminar este empleado?"),
                                primaryButton: .destructive(Text("Eliminar"), action: {
                                    if let cliente = empleadosSeleccionado {
                                        empleadoManager.handleDeleteTapped(empleado: empleado)
                                        print("Empleado eliminado", empleado)
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
            .overlay(newEmpleadoButton, alignment: .bottom)
        }.background(Color.white)
    }
    
    private var newEmpleadoButton: some View {
        
        NavigationLink(destination: EmpleadoView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nuevo Empleado")
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

struct EmpleadoListView_Previews: PreviewProvider {
    static var previews: some View {
        EmpleadoListView()
    }
}
