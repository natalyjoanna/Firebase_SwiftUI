import SwiftUI

struct ProductosView: View {
    @State private var textAlert = ""
    @State private var mostrarAlerta = false
    
    @ObservedObject var productManager = ProductViewModel()
    var mode: Mode?
    
    init(product: Product? = nil, mode: Mode?) {
        productManager = ProductViewModel(product: product ?? Product(Nombre: "", Descripcion: "", Unidad: 0, Costo: 0.0, Precio: 0.0, Utilidad: 0.0))
        //print("Producto recibido:", productManager.product)
        self.mode = mode
        
    }
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Text(mode == .new ? "Nuevo Producto" : productManager.product.Nombre)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                    
                    Image("producticon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.vertical, 5)
                    
                    VStack {
                        InputView(text: $productManager.product.Nombre, title: "Nombre", placeholder: "Ingrese el nombre del producto")
                        InputView(text: $productManager.product.Descripcion, title: "Descripcion", placeholder: "Ingrese la descripcion del producto")
                        InputView(text: Binding<String>(
                            get: { String(productManager.product.Unidad) },
                                set: { if let value = Int($0) { productManager.product.Unidad = value } }
                                ), title: "Unidades", placeholder: "Ingrese las unidades")
                        InputView(text: Binding<String>(
                            get: { String(productManager.product.Costo) },
                                set: { if let value = Float($0) { productManager.product.Costo = value } }
                                ), title: "Costo", placeholder: "Ingrese el costo del producto")
                        InputView(text: Binding<String>(
                            get: { String(productManager.product.Precio) },
                                set: { if let value = Float($0) { productManager.product.Precio = value } }
                                ), title: "Precio", placeholder: "Ingrese el precio del producto")
                        InputView(text: Binding<String>(
                            get: { String(productManager.product.Utilidad) },
                                set: { if let value = Float($0) { productManager.product.Utilidad = value } }
                                ), title: "Utilidad", placeholder: "Ingrese la utilidad del producto")

                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                                    
                    Button {
                        productManager.handleDoneTapped()
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
                              message: Text(mode == .new ? "El producto se ha registrado correctamente" : "El producto se ha actualizado correctamente"),
                              dismissButton: .default(Text("Aceptar")))
                        }

                    
                    
                    Spacer()
                    
                    NavigationLink(destination: ProductListView(), label:{
                        HStack(spacing: 3) {
                            Text("Listado de productos")
                            
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

struct ProductosView_Previews: PreviewProvider {
    static var previews: some View {
        ProductosView(mode: .new)
    }
}
