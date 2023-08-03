import SwiftUI

struct NavigationButtonView<Destination: View>: View {
    let text: String
    let destination: Destination
    
    var body: some View {
        
        NavigationLink(destination: destination) {
                HStack {
                    Text(text)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color(.white))
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(CustomColor.drSimiBlue)
                .cornerRadius(10)
                .padding(.top, 24)
            }
    }
}

struct NavigationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonView(text: "texto", destination: Text("Destination View"))
    }
}
