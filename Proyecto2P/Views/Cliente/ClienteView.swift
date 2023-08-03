import FirebaseAuth
import FirebaseCore

import SwiftUI

struct ClienteView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    let gender = ["Masculino", "Femenino", "Otro"]
    @State private var isAdmin = false

    
    @ObservedObject var clienteManager = ClienteViewModel()
    var mode: Mode?
    
    init(cliente: Cliente? = nil, mode: Mode?) {
        clienteManager = ClienteViewModel(cliente: cliente ?? Cliente(Nombre: "", Apellido: "", Edad: 0, Telefono: ""))
        //print("Usuario recibido:", userManager.user)
        self.mode = mode
        
    }

    var body: some View {
        ZStack {
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Cliente Nuevo" : clienteManager.cliente.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                    Image("clienteicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $clienteManager.cliente.Nombre, title: "Nombre", placeholder: "Ingrese su nombre")
                        InputView(text: $clienteManager.cliente.Apellido, title: "Apellido", placeholder: "Ingrese su apellido")
                        InputView(text: Binding<String>(
                                get: { String(clienteManager.cliente.Edad) },
                                set: { if let value = Int($0) { clienteManager.cliente.Edad = value } }
                                ), title: "Edad", placeholder: "Ingrese su edad")
                        //InputView(text: $userManager.user.genero, title: "Género", placeholder: "Ingrese su género")
                        InputView(text: $clienteManager.cliente.Telefono, title: "Telefono", placeholder: "Ingrese su telefono")
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        clienteManager.handleDoneTapped()
                        mostrarAlerta = true
                    } label: {
                        HStack {
                            Text(mode == .new ? "REGISTRAR" : "ACTUALIZAR")
                                    .fontWeight(.semibold)
                        }
                        .foregroundColor(Color(.white))
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(CustomColor.drSimiBlue)
                    .cornerRadius(10)
                    .padding(.top, 24)
                    .disabled(!isAdmin)
                    .opacity(isAdmin ? 1.0 : 0.5)
                    .alert(isPresented: $mostrarAlerta) {
                        Alert(title: Text(mode == .new ? "Registro Exitoso" : "Actualizacion Exitosa"),
                              message: Text(mode == .new ? "El cliente se ha registrado correctamente" : "El cliente se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: ListClienteView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de clientes")
                            
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                        .foregroundColor(CustomColor.drSimiBlue)
                    })
                }
                
            }
        }.background(Color.white)
            .onAppear {
                guard let currentUser = Auth.auth().currentUser else { return }
                
                if (currentUser.email == "admintest@hotmail.com"){
                    isAdmin = true
                } else {
                    isAdmin = false
                }
            }

    }
}

struct ClienteView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteView(mode: .new)
    }
}
