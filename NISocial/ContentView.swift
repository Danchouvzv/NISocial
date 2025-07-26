import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }
                .tag(0)

            LostFoundView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Потеряно/Найдено")
                }
                .tag(1)

            EventsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("События")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профиль")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}



 