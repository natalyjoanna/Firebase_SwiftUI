import SwiftUI

struct UserListView: View {
    @ObservedObject var userManager = UserViewModel()
    @State private var usuarioSeleccionado: User?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""

    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("userpic")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("USUARIOS")
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
                        ForEach(userManager.users, id: \.id) { user in
                            NavigationLink(destination: UserView(user: user, mode: .edit)) {
                            HStack {
                                Image("userpic")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.system(size: 32))
                                    .frame(width: 40, height: 40)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(user.Nombre)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(user.Apellido)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.purple))
                                }
                                
                                Spacer()
                                
                            }
                            .swipeActions {
                                Button(action: {
                                    usuarioSeleccionado = user
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
                                        if let usuario = usuarioSeleccionado {
                                            userManager.handleDeleteTapped(user: usuario)
                                            print("Usuario eliminado", usuario)
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
                .overlay(newUserButton, alignment: .bottom)
            }
    }
            
    private var newUserButton: some View {
        
        NavigationLink(destination: UserView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nuevo Usuario")
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

    
    struct UserListView_Previews: PreviewProvider {
        static var previews: some View {
            UserListView()
        }
    }

