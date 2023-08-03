import FirebaseAuth
import FirebaseCore

import SwiftUI

struct ProveedorView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    @State private var NombreInsumos: [String] = []
    @State private var isAdmin = false
    
    
    @ObservedObject var proveedorManager = ProveedorViewModel()
    @ObservedObject var insumosManager = InsumosViewModel()
    var mode: Mode?
    
    init(proveedor: Proveedor? = nil, mode: Mode?) {
        proveedorManager = ProveedorViewModel(proveedor: proveedor ?? Proveedor(Nombre: "", Correo: "", idInsumo: "", Telefono: ""))
        self.mode = mode
        
        print("Insumos:", NombreInsumos)
        
    }
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Proveedor Nuevo" : proveedorManager.proveedor.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                    Image("proveedoricon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $proveedorManager.proveedor.Nombre, title: "Nombre", placeholder: "Ingrese su nombre")
                        InputView(text: $proveedorManager.proveedor.Correo, title: "Correo", placeholder: "Ingrese su correo")
                        ComboBoxView(selection: $proveedorManager.proveedor.idInsumo, title: "Insumo entregado", array: NombreInsumos)
                        //InputView(text: $userManager.user.genero, title: "Género", placeholder: "Ingrese su género")
                        InputView(text: $proveedorManager.proveedor.Telefono, title: "Telefono", placeholder: "Ingrese su telefono")
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    Button {
                        proveedorManager.handleDoneTapped()
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
                              message: Text(mode == .new ? "El proveedor se ha registrado correctamente" : "El proveedor se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                    }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: ProveedoresListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de proveedores")
                            
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                        .foregroundColor(CustomColor.drSimiBlue)
                    })
                }
                
            }.onAppear{
                insumosManager.llenarComboBox { nombreObtenidos in
                    NombreInsumos = nombreObtenidos
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
}


struct ProveedorView_Previews: PreviewProvider {
    static var previews: some View {
        ProveedoresListView()
    }
}
