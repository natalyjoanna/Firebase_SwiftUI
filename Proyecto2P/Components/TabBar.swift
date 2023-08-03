import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case message
    case person
    case gear
}

struct TabBar : View{
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    var body: some View {
            VStack {
                HStack {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        Spacer()
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                            .foregroundColor(selectedTab == tab ? .blue : .black)
                            .onTapGesture{
                                if (selectedTab == .house){
                                    NavigationLink(destination: MenuView()){
                                        EmptyView()
                                    }
                                } else if (selectedTab == .gear) {
                                    NavigationLink(destination: ContentView()){
                                        EmptyView()
                                    }
                                }
                            }
                        Spacer()
                        
                    }
                }
                .frame(width: nil, height: 60)
                .background(.thinMaterial)
                .cornerRadius(10)
                .padding()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.house))
    }
}
