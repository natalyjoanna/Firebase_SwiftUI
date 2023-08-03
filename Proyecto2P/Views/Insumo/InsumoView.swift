import FirebaseAuth
import FirebaseCore

import SwiftUI

struct InsumoView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    let categ = ["Higiene", "Infantil", "Cosmetica", "Dermatologica", "Medicina"]
    @State private var isAdmin = false
    
    @ObservedObject var insumoManager = InsumosViewModel()
    var mode: Mode?
    
    init(insumo: Insumos? = nil, mode: Mode?) {
        insumoManager = InsumosViewModel(insumo: insumo ?? Insumos(Nombre: "", Cantidad: 0, Precio: 0, Categoria: ""))
        //print("Usuario recibido:", userManager.user)
        self.mode = mode
        
    }
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Insumo Nuevo" : insumoManager.insumo.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                    
                    Image("insumos")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $insumoManager.insumo.Nombre, title: "Nombre", placeholder: "Ingrese su nombre")
                        InputView(text: Binding<String>(
                            get: { String(insumoManager.insumo.Cantidad) },
                                set: { if let value = Int($0) { insumoManager.insumo.Cantidad = value } }
                                ), title: "Cantidad", placeholder: "Ingrese su cantidad")
                        InputView(text: Binding<String>(
                            get: { String(insumoManager.insumo.Precio) },
                                set: { if let value = Float($0) { insumoManager.insumo.Precio = value } }
                                ), title: "Precio", placeholder: "Ingrese el precio")
                        ComboBoxView(selection: $insumoManager.insumo.Categoria, title: "Categoria", array: categ)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        insumoManager.handleDoneTapped()
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
                              message: Text(mode == .new ? "El insumo se ha registrado correctamente" : "El insumo se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: InsumosListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de insumos")
                            
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

struct InsumoView_Previews: PreviewProvider {
    static var previews: some View {
        InsumoView(mode: .new)
    }
}
