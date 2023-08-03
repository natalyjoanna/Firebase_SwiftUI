import SwiftUI

struct ProductListView: View {
    @ObservedObject var productManager = ProductViewModel()
    @State private var productoSeleccionado: Product?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("producticon")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("PRODUCTOS")
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
                    ForEach(productManager.products, id: \.id) { product in
                        NavigationLink(destination: ProductosView(product: product, mode: .edit)) {
                        HStack {
                            Image("producticon")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(product.Nombre)
                                    .font(.system(size: 16, weight: .bold))
                                Text(product.Descripcion)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.purple))
                            }
                            
                            Spacer()
                        }
                        .swipeActions {
                            Button(action: {
                                productoSeleccionado = product
                                mostrarAlerta = true
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $mostrarAlerta) {
                            Alert(
                                title: Text("Eliminar Producto"),
                                message: Text("¿Estás seguro de que quieres eliminar este producto?"),
                                primaryButton: .destructive(Text("Eliminar"), action: {
                                    if let producto = productoSeleccionado {
                                        productManager.handleDeleteTapped(product: producto)
                                        print("Producto eliminado", producto)
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
            .overlay(newProductButton, alignment: .bottom)
        }
    }
    
    private var newProductButton: some View {
        
        NavigationLink(destination: ProductosView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nuevo Producto")
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

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
