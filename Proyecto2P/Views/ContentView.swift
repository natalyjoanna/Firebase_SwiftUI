import SwiftUI
import FirebaseAuth
import FirebaseCore
import Firebase


struct ContentView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    @State private var isLoggedIn = false

    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                VStack{
                    
                    TopBar()
                    
                    Text("Inicio de Sesion")
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                    Image("drsimi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 30)
                    
                    
                        HStack  {
                                Text("Bienvenido")
                                    .fontWeight(.bold)
                                    .foregroundColor(CustomColor.drSimiBlue)
                                    
                                Text("Inicie sesión")
                                    .foregroundColor(CustomColor.drSimiBlue)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    VStack(spacing: 24) {
                        InputView(text: $email, title: "Correo", placeholder: "Ingrese su correo")
                        InputView(text: $password, title: "Contraseña", placeholder: "Ingrese su contraseña", isSecuredField: true)
                        
                    }.padding(.horizontal)
                        .padding(.top, 12)
                    
            Button(action: {
                if email.isEmpty || password.isEmpty {
                    mostrarAlerta = true
                    textAlert = "Ingrese el correo y la contraseña"
                } else {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            print(error.localizedDescription)
                            mostrarAlerta = true
                            textAlert = "Correo o contraseña incorrectos"
                        } else {
                            isLoggedIn = true
                        }
                    }
                }
                }) {
                    Text("INICIAR SESIÓN")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(CustomColor.drSimiBlue)
                        .cornerRadius(10)
                        .padding(.top, 24)
                }
                    
                    Spacer()
                    
                }
            }.background(Color.white)
        }.alert(isPresented: $mostrarAlerta) {
            Alert(title: Text("Alerta"), message: Text(textAlert), dismissButton: .default(Text("OK")))
        }
        .background(Color.white)
        .fullScreenCover(isPresented: $isLoggedIn) {
                    MenuView()
                }
    }
}

struct CustomColor {
    static let drSimiBlue = Color("drsimiColors")
}

struct TopBar : View {
    var body: some View{
        HStack {
            Text("Farmacias Similares")
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(CustomColor.drSimiBlue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
