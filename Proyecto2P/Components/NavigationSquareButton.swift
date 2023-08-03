import SwiftUI

struct NavigationSquareButton<Destination: View>: View {
    let imageName: String
    let destination: Destination
    let text: String

    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(text)
                    .font(.caption)
            }
            .frame(width: 150, height: 150)
            .background(CustomColor.drSimiBlue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct NavigationSquareButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSquareButton(imageName: "", destination: ProveedoresListView(), text: "")
    }
}
