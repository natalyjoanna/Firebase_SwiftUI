import FirebaseAuth
import FirebaseCore

import SwiftUI

struct EmpleadoView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    @State private var isAdmin = false
    
    @ObservedObject var empleadoManager = EmpleadoViewModel()
    var mode: Mode?
    
    init(empleado: Empleado? = nil, mode: Mode?) {
        empleadoManager = EmpleadoViewModel(empleado: empleado ?? Empleado(Nombre: "", Apellido: "", Turno: "", Correo: "", Contraseña: ""))
        //print("Usuario recibido:", userManager.user)
        self.mode = mode
        
    }
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Empleado Nuevo" : empleadoManager.empleado.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                    Image("empleado")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $empleadoManager.empleado.Nombre, title: "Nombre", placeholder: "Ingrese su nombre")
                        InputView(text: $empleadoManager.empleado.Apellido, title: "Apellido", placeholder: "Ingrese su apellido")
                        InputView(text: $empleadoManager.empleado.Turno, title: "Turno", placeholder: "Ingrese su turno")
                        InputView(text: $empleadoManager.empleado.Correo, title: "Correo", placeholder: "Ingrese su correo")
                        InputView(text: $empleadoManager.empleado.Contraseña, title: "Contraseña", placeholder: "Ingrese su contraseña", isSecuredField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        empleadoManager.handleDoneTapped()
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
                              message: Text(mode == .new ? "El empleado se ha registrado correctamente" : "El empleado se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: EmpleadoListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de empeados")
                            
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

struct EmpleadoView_Previews: PreviewProvider {
    static var previews: some View {
        EmpleadoView(mode: .new)
    }
}
