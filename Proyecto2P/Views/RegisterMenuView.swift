//
//  RegisterMenuView.swift
//  Proyecto2P
//
//  Created by ISSC_612_2023 on 24/04/23.
//

import SwiftUI

struct RegisterMenuView: View {
    var body: some View {
        
        ZStack{
                
                LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    NavigationButtonView(text: "Usuario", destination: UserView(mode: .new))
                    NavigationButtonView(text: "Producto", destination: ProductosView(mode: .new))
                }
            }
    }
}

struct RegisterMenuView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterMenuView()
    }
}
