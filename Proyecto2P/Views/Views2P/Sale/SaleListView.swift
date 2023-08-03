import SwiftUI

struct SaleListView: View {
    @ObservedObject var saleManager = SaleViewModel()
    @State private var ventaSeleccionado: Sale?
    @State private var mostrarAlerta = false
    @State private var textAlert = ""
    
    private var navBar: some View {
        HStack(spacing: 16) {
            
            Image("salespic")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("VENTAS")
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
                    ForEach(saleManager.sales, id: \.id) { sale in
                        NavigationLink(destination: SalesView(sale: sale, mode: .edit)) {
                        HStack {
                            Image("salespic")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 32))
                                .frame(width: 40, height: 40)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(sale.Nombre)
                                    .font(.system(size: 16, weight: .bold))
                                Text(String(sale.Piezas))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.purple))
                            }
                            
                            Spacer()
                            
                        }
                        .swipeActions {
                            Button(action: {
                                ventaSeleccionado = sale
                                mostrarAlerta = true
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $mostrarAlerta) {
                            Alert(
                                title: Text("Eliminar Venta"),
                                message: Text("¿Estás seguro de que quieres eliminar esta venta?"),
                                primaryButton: .destructive(Text("Eliminar"), action: {
                                    if let venta = ventaSeleccionado {
                                        saleManager.handleDeleteTapped(sale: venta)
                                        print("Venta eliminada", venta)
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
            .overlay(newSaleButton, alignment: .bottom)
        }
    }
    
    private var newSaleButton: some View {
        
        NavigationLink(destination: SalesView(mode: .new)) {
                HStack {
                    Spacer()
                    Text("+ Nueva Venta")
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

struct SaleListView_Previews: PreviewProvider {
    static var previews: some View {
        SaleListView()
    }
}
