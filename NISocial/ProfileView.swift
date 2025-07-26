import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var isDarkMode = false
    @State private var animateStats = false
    @State private var animateAchievements = false
    @Namespace private var animation
    
    let user = User.mockUser
    
    var body: some View {
        NavigationView {
            ZStack {
                // Динамический градиентный фон
                AnimatedGradientBackground()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Креативный хедер профиля
                        CreativeProfileHeader(user: user, animation: animation)
                        
                        // Интерактивная статистика
                        InteractiveStatsSection(user: user, animateStats: $animateStats)
                            .padding(.top, 24)
                        
                        // Достижения и бейджи
                        AchievementsSection(animateAchievements: $animateAchievements)
                            .padding(.top, 24)
                        
                        // Табы контента
                        ContentTabsSection(selectedTab: $selectedTab, animation: animation)
                            .padding(.top, 24)
                        
                        // Контент табов
                        TabContentView(selectedTab: selectedTab, user: user)
                            .padding(.top, 16)
                    }
                    .padding(.bottom, 100)
                }
                
                // FAB кнопки
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 16) {
                            // Кнопка настроек
                            Button(action: { showingSettings = true }) {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 50, height: 50)
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "gearshape.fill")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            // Кнопка редактирования
                            Button(action: { showingEditProfile = true }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        )
                                    
                                    Image(systemName: "pencil")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: user)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateStats = true
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.4)) {
                animateAchievements = true
            }
        }
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Основной градиент
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.08),
                    Color.pink.opacity(0.05),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Анимированные круги
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.15), .purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: animate ? -50 : -100, y: animate ? -100 : -50)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.1), .pink.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 150, height: 150)
                .offset(x: animate ? 100 : 50, y: animate ? 50 : 100)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear { animate = true }
    }
}

// MARK: - Creative Profile Header
struct CreativeProfileHeader: View {
    let user: User
    var animation: Namespace.ID
    @State private var avatarScale = false
    @State private var showPulse = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Анимированный аватар
            ZStack {
                // Пульсирующий фон
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(showPulse ? 1.2 : 1.0)
                    .opacity(showPulse ? 0.5 : 0.8)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showPulse)
                
                // Основной аватар
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
                    .scaleEffect(avatarScale ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: avatarScale)
                    .matchedGeometryEffect(id: "avatar", in: animation)
                
                // Инициалы
                Text(String(user.name.prefix(2)))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                // Статус онлайн
                Circle()
                    .fill(.green)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .offset(x: 35, y: 35)
            }
            .onAppear {
                avatarScale = true
                showPulse = true
            }
            
            // Информация пользователя
            VStack(spacing: 8) {
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("@\(user.name.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("NIS HBN • 11 класс • \(user.grade)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Бейдж уровня
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text("Уровень \(user.profile.level)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
}

// MARK: - Interactive Stats Section
struct InteractiveStatsSection: View {
    let user: User
    @Binding var animateStats: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                InteractiveStatCard(
                    title: "Постов",
                    value: "\(user.profile.statistics.postsCount)",
                    icon: "doc.text.fill",
                    color: .blue,
                    animateStats: animateStats
                )
                
                InteractiveStatCard(
                    title: "Найдено",
                    value: "\(user.profile.statistics.foundItemsCount)",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    animateStats: animateStats
                )
                
                InteractiveStatCard(
                    title: "Лайков",
                    value: "\(user.profile.statistics.likesCount)",
                    icon: "heart.fill",
                    color: .red,
                    animateStats: animateStats
                )
            }
            
            // Прогресс уровня
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Прогресс до следующего уровня")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(user.profile.statistics.experiencePoints) XP")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: Double(user.profile.statistics.experiencePoints % 100), total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(y: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.ultraThinMaterial)
                    )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct InteractiveStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animateStats: Bool
    @State private var scale = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            .scaleEffect(scale ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: scale)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .scaleEffect(animateStats ? 1.0 : 0.8)
                .opacity(animateStats ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateStats)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                scale = false
            }
        }
    }
}

// MARK: - Achievements Section
struct AchievementsSection: View {
    @Binding var animateAchievements: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Достижения")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(Achievement.mockAchievements.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(Achievement.mockAchievements.enumerated()), id: \.element.id) { index, achievement in
                        AchievementCard(
                            achievement: achievement,
                            index: index,
                            animateAchievements: animateAchievements
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let index: Int
    let animateAchievements: Bool
    @State private var isUnlocked = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: achievement.isUnlocked ? [.yellow, .orange] : [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: achievement.isUnlocked ? .yellow.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            .scaleEffect(animateAchievements ? 1.0 : 0.8)
            .opacity(animateAchievements ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateAchievements)
            
            Text(achievement.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(achievement.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 80)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .onAppear {
            isUnlocked = achievement.isUnlocked
        }
    }
}

// MARK: - Content Tabs Section
struct ContentTabsSection: View {
    @Binding var selectedTab: Int
    var animation: Namespace.ID
    
    private let tabs = ["Активность", "Посты", "Настройки"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tabs[index])
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedTab == index ? .primary : .secondary)
                        
                        // Анимированный индикатор
                        if selectedTab == index {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "tab", in: animation)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 3)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Tab Content View
struct TabContentView: View {
    let selectedTab: Int
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            switch selectedTab {
            case 0:
                ActivityTabView(user: user)
            case 1:
                PostsTabView(user: user)
            case 2:
                SettingsTabView()
            default:
                EmptyView()
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Activity Tab
struct ActivityTabView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(user.profile.recentActivity.prefix(5), id: \.id) { activity in
                ActivityRow(activity: activity)
            }
        }
    }
}

struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(activity.type.color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: activity.type.icon)
                    .font(.caption)
                    .foregroundColor(activity.type.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(activity.date, style: .relative)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Posts Tab
struct PostsTabView: View {
    let user: User
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(0..<6, id: \.self) { index in
                PostCard(index: index)
            }
        }
    }
}

struct PostCard: View {
    let index: Int
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay(
                    VStack {
                        Image(systemName: ["doc.text", "photo", "video", "link"][index % 4])
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Пост #\(index + 1)")
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    Button(action: { isLiked.toggle() }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.caption)
                            .foregroundColor(isLiked ? .red : .secondary)
                    }
                    
                    Text("\(Int.random(in: 5...50))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Settings Tab
struct SettingsTabView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var autoSaveEnabled = true
    
    var body: some View {
        VStack(spacing: 16) {
            SettingsRow(
                icon: "bell.fill",
                title: "Уведомления",
                subtitle: "Получать уведомления о новых объявлениях",
                isToggle: true,
                toggleValue: $notificationsEnabled
            )
            
            SettingsRow(
                icon: "moon.fill",
                title: "Тёмная тема",
                subtitle: "Автоматическое переключение",
                isToggle: true,
                toggleValue: $darkModeEnabled
            )
            
            SettingsRow(
                icon: "icloud.fill",
                title: "Автосохранение",
                subtitle: "Сохранять черновики автоматически",
                isToggle: true,
                toggleValue: $autoSaveEnabled
            )
            
            Divider()
            
            SettingsRow(
                icon: "questionmark.circle.fill",
                title: "Помощь",
                subtitle: "FAQ и поддержка",
                isToggle: false
            )
            
            SettingsRow(
                icon: "info.circle.fill",
                title: "О приложении",
                subtitle: "Версия 1.0.0",
                isToggle: false
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isToggle: Bool
    var toggleValue: Binding<Bool>? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isToggle, let toggleValue = toggleValue {
                Toggle("", isOn: toggleValue)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Настройки")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var bio = ""
    @State private var grade = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Редактировать профиль")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
} 