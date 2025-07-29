import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        TabView {
            ChallengeView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Challenge")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Assistant")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .accentColor(Color("PrimaryColor"))
        .onAppear {
            // Ensure tab bar has proper background
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
} 
 