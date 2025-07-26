import SwiftUI

struct HomeView: View {
    @Namespace private var animation
    @State private var animateContent = false
    @State private var selectedSection: HomeSection? = nil
    @State private var showingNotifications = false
    
    let user = User.mockUser
    
    var body: some View {
        NavigationView {
            ZStack {
                // Минималистичный градиентный фон
                MinimalGradientBackground()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Элегантный хедер
                        ElegantHeader(user: user, animation: animation)
                        
                        // Мотивационный баннер
                        MotivationalBanner()
                        
                        // Быстрые действия
                        QuickActionsSection(selectedSection: $selectedSection, animation: animation)
                        
                        // Статистика активности
                        ActivityStatsSection(user: user)
                        
                        // Последние события
                        RecentEventsSection()
                        
                        // Последние находки
                        RecentLostFoundSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                
                // FAB кнопка
                FloatingActionButton()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Minimal Gradient Background
struct MinimalGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Основной градиент
                            LinearGradient(
                    colors: [
                        Color.primary.opacity(0.02),
                        Color.primary.opacity(0.01)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            
            // Тонкие анимированные линии
            GeometryReader { geometry in
                ZStack {
                    // Горизонтальные линии
                    ForEach(0..<3, id: \.self) { index in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.blue.opacity(0.1),
                                        Color.purple.opacity(0.05),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1)
                            .offset(y: CGFloat(index * 200) + (animate ? 50 : 0))
                            .opacity(animate ? 0.8 : 0.3)
                            .animation(
                                .easeInOut(duration: 8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 2),
                                value: animate
                            )
                    }
                }
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Elegant Header
struct ElegantHeader: View {
    let user: User
    var animation: Namespace.ID
    @State private var showGreeting = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(greetingText)
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                        .opacity(showGreeting ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.5), value: showGreeting)
                    
                    Text(user.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .opacity(showGreeting ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.7), value: showGreeting)
                }
                
                Spacer()
                
                // Уведомления
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "bell")
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        // Индикатор уведомлений
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 8, y: -8)
                    }
                }
            }
            
            // Аватар пользователя
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Text(String(user.name.prefix(1)))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .scaleEffect(showGreeting ? 1 : 0.8)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.9), value: showGreeting)
        }
        .onAppear { showGreeting = true }
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Доброе утро"
        case 12..<17: return "Добрый день"
        case 17..<22: return "Добрый вечер"
        default: return "Доброй ночи"
        }
    }
}

// MARK: - Motivational Banner
struct MotivationalBanner: View {
    @State private var showBanner = false
    
    let messages = [
        "Помогай другим - находи потерянные вещи! 🎯",
        "Участвуй в событиях - развивайся вместе с нами! 🚀",
        "Твоя помощь делает школу лучше! ✨",
        "Каждый день - новые возможности! 🌟"
    ]
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundColor(.orange)
            
            Text(messages.randomElement() ?? messages[0])
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .opacity(showBanner ? 1 : 0)
        .offset(y: showBanner ? 0 : 20)
        .animation(.easeInOut(duration: 0.8).delay(1.2), value: showBanner)
        .onAppear { showBanner = true }
    }
}

// MARK: - Quick Actions Section
struct QuickActionsSection: View {
    @Binding var selectedSection: HomeSection?
    var animation: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Быстрые действия")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(HomeSection.allCases, id: \.self) { section in
                    QuickActionCard(
                        section: section,
                        isSelected: selectedSection == section,
                        animation: animation
                    ) {
                        selectedSection = section
                    }
                }
            }
        }
    }
}

struct QuickActionCard: View {
    let section: HomeSection
    let isSelected: Bool
    var animation: Namespace.ID
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPressed = false
            }
            action()
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: section.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: section.gradientColors[0].opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: section.icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                Text(section.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .matchedGeometryEffect(id: "section_\(section.title)", in: animation)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Activity Stats Section
struct ActivityStatsSection: View {
    let user: User
    @State private var showStats = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Твоя активность")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Найдено",
                    value: "\(user.profile.statistics.foundItemsCount)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatCard(
                    title: "События",
                    value: "\(user.profile.statistics.eventsAttended)",
                    icon: "calendar.badge.plus",
                    color: .blue
                )
                
                StatCard(
                    title: "Посты",
                    value: "\(user.profile.statistics.postsCount)",
                    icon: "doc.text.fill",
                    color: .purple
                )
            }
        }
        .opacity(showStats ? 1 : 0)
        .offset(y: showStats ? 0 : 20)
        .animation(.easeInOut(duration: 0.8).delay(1.5), value: showStats)
        .onAppear { showStats = true }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Recent Events Section
struct RecentEventsSection: View {
    @State private var showEvents = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ближайшие события")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Все") {
                    // Навигация к событиям
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Event.mockEvents.prefix(3), id: \.id) { event in
                        RecentEventCard(event: event)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .opacity(showEvents ? 1 : 0)
        .offset(y: showEvents ? 0 : 20)
        .animation(.easeInOut(duration: 0.8).delay(1.8), value: showEvents)
        .onAppear { showEvents = true }
    }
}

struct RecentEventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Иконка категории
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: event.category.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: event.category.icon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 140)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Recent Lost Found Section
struct RecentLostFoundSection: View {
    @State private var showItems = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Последние находки")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Все") {
                    // Навигация к lost & found
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(LostFoundItem.mockItems.prefix(3), id: \.id) { item in
                        RecentItemCard(item: item)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .opacity(showItems ? 1 : 0)
        .offset(y: showItems ? 0 : 20)
        .animation(.easeInOut(duration: 0.8).delay(2.1), value: showItems)
        .onAppear { showItems = true }
    }
}

struct RecentItemCard: View {
    let item: LostFoundItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Статус
            HStack {
                Circle()
                    .fill(item.status.color)
                    .frame(width: 8, height: 8)
                
                Text(item.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(item.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 140)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPressed = false
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Home Section Enum
enum HomeSection: CaseIterable {
    case lostFound
    case events
    case profile
    case settings
    
    var title: String {
        switch self {
        case .lostFound: return "Потеряно/\nНайдено"
        case .events: return "События"
        case .profile: return "Профиль"
        case .settings: return "Настройки"
        }
    }
    
    var icon: String {
        switch self {
        case .lostFound: return "magnifyingglass"
        case .events: return "calendar"
        case .profile: return "person.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .lostFound: return [.orange, .red]
        case .events: return [.blue, .cyan]
        case .profile: return [.purple, .pink]
        case .settings: return [.gray, .blue]
        }
    }
}

#Preview {
    HomeView()
} 