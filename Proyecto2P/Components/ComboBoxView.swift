//
//  ComboBoxView.swift
//  Proyecto2P
//
//  Created by Nataly Jonanna on 20/05/23.
//

import SwiftUI

struct ComboBoxView: View {
    @Binding var selection: String
    let title: String
    let array: [String]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12) {
            HStack{
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
                Spacer()
                
                Picker(
                    selection: $selection,
                    label:
                        HStack {
                            Text(selection)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.3),radius: 10, x: 0, y: 10)
                    ,
                    content: {
                        ForEach(array, id: \.self) { option in
                            HStack {
                                Text(option)
                                    .foregroundColor(CustomColor.drSimiBlue)
                            }
                        }
                    }
                )
                .pickerStyle(WheelPickerStyle())
            }
            .padding(.vertical, -40 )
                       
            Divider()
        }
    }
}



struct ComboBoxView_Previews: PreviewProvider {
    static var previews: some View {
        ComboBoxView(selection: .constant(""), title: "ejemplo", array: ["cosa1", "cosa2", "cosa3"])
    }
}
