import FirebaseAuth
import FirebaseCore
import SwiftUI

struct MenuView: View {
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var selectedTab : Tab = .house
    @State private var isAdmin = false
    
    var body: some View {
        NavigationView {
            ZStack{
               
                VStack{
                    
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(isAdmin == true ? "Hola Admin" : "Hola Usuario")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Buen dia!!")
                        }.foregroundColor(.black)
                        
                        Spacer(minLength: 0)
                        
                        Image("adminicon")
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                    Spacer(minLength: 0)
                    
                    Image("similareslogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .padding(.vertical, 20)
                    
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        NavigationSquareButton(imageName: "clienteslist", destination: ListClienteView(), text: "Clientes")
                        NavigationSquareButton(imageName: "empleadoslist", destination: EmpleadoListView(), text: "Empleados")
                        NavigationSquareButton(imageName: "proveedoreslist", destination: ProveedoresListView(), text: "Proveedores")
                        NavigationSquareButton(imageName: "insumoslist", destination: InsumosListView(), text: "Insumos")
                    }.padding(.bottom, 100)
                    
                    TabBar(selectedTab: $selectedTab)
                    
                }.padding()
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
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
