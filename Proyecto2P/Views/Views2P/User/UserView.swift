//
import SwiftUI

enum Mode {
  case new
  case edit
}

struct UserView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    let gender = ["Masculino", "Femenino", "Otro"]
    
    @ObservedObject var userManager = UserViewModel()
    var mode: Mode?
    
    init(user: User? = nil, mode: Mode?) {
        userManager = UserViewModel(user: user ?? User(Nombre: "", Apellido: "", Edad: 0, Genero: "", Correo: "", Contraseña: ""))
        //print("Usuario recibido:", userManager.user)
        self.mode = mode
        
    }

    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Usuario Nuevo" : userManager.user.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                    
                    Image("usuario")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $userManager.user.Nombre, title: "Nombre", placeholder: "Ingrese su nombre")
                        InputView(text: $userManager.user.Apellido, title: "Apellido", placeholder: "Ingrese su apellido")
                        InputView(text: Binding<String>(
                                get: { String(userManager.user.Edad) },
                                set: { if let value = Int($0) { userManager.user.Edad = value } }
                                ), title: "Edad", placeholder: "Ingrese su edad")
                        //InputView(text: $userManager.user.genero, title: "Género", placeholder: "Ingrese su género")
                        ComboBoxView(selection: $userManager.user.Genero, title: "Genero", array: gender)
                        InputView(text: $userManager.user.Correo, title: "Correo", placeholder: "Ingrese su correo").autocapitalization(.none)
                        InputView(text: $userManager.user.Contraseña, title: "Contraseña", placeholder: "Ingrese su contraseña")
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        userManager.handleDoneTapped()
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
                              message: Text(mode == .new ? "El usuario se ha registrado correctamente" : "El usuario se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: UserListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de usuarios")
                            
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

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(mode: .new)
    }
}
