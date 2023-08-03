//
//  InputView.swift
//  Proyecto2P
//
//  Created by Nataly Jonanna on 15/05/23.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecuredField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.system(size: 18))
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    
                    if isSecuredField {
                        ZStack(alignment: .leading) {
                            if text.isEmpty {
                                Text(placeholder)
                                    .foregroundColor(.black.opacity(0.5))
                                    .font(.system(size: 16))
                            }
                            SecureField("", text: $text)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    } else {
                        ZStack(alignment: .leading) {
                            if text.isEmpty {
                                Text(placeholder)
                                    .foregroundColor(.black.opacity(0.5))
                                    .font(.system(size: 16))
                            }
                            TextField("", text: $text)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    }
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
