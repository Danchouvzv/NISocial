import SwiftUI

struct HomeView: View {
    @Namespace private var animation
    @State private var animateContent = false
    @State private var selectedTab = 0
    @State private var showingNotifications = false
    @State private var showingQuickActions = false
    @State private var searchText = ""
    
    let user = User.mockUser
    
    var body: some View {
        ZStack {
            // Современный градиентный фон
            ModernGradientBackground()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Улучшенный хедер с поиском
                    ModernHeader(user: user, searchText: $searchText, animation: animation)
                    
                    // Быстрые действия с улучшенной навигацией
                    EnhancedQuickActions(selectedTab: $selectedTab, animation: animation)
                    
                    // Статистика с анимацией
                    AnimatedStatsSection(user: user)
                    
                    // Ближайшие события
                    UpcomingEventsSection()
                    
                    // Последние находки
                    RecentLostFoundSection()
                    
                    // Активность сообщества
                    CommunityActivitySection()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            
            // Улучшенная FAB кнопка
            EnhancedFloatingActionButton(showingQuickActions: $showingQuickActions)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Modern Gradient Background
struct ModernGradientBackground: View {
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
            
            // Анимированные элементы
            GeometryReader { geometry in
                ZStack {
                    // Плавающие круги
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.blue.opacity(0.1),
                                        Color.purple.opacity(0.05),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: CGFloat.random(in: 50...150))
                            .offset(
                                x: CGFloat.random(in: -50...geometry.size.width + 50),
                                y: CGFloat.random(in: -50...geometry.size.height + 50)
                            )
                            .opacity(animate ? 0.6 : 0.2)
                            .animation(
                                .easeInOut(duration: Double.random(in: 8...12))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 1.5),
                                value: animate
                            )
                    }
                }
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Modern Header
struct ModernHeader: View {
    let user: User
    @Binding var searchText: String
    var animation: Namespace.ID
    @State private var showGreeting = false
    @State private var showSearch = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(greetingText)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .opacity(showGreeting ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6).delay(0.3), value: showGreeting)
                    
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .opacity(showGreeting ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6).delay(0.5), value: showGreeting)
                }
                
                Spacer()
                
                // Уведомления
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 48, height: 48)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "bell.fill")
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        // Индикатор уведомлений
                        Circle()
                            .fill(.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 10, y: -10)
                    }
                }
            }
            
            // Поисковая строка
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.title3)
                
                TextField("Поиск событий, вещей...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .opacity(showSearch ? 1 : 0)
            .offset(y: showSearch ? 0 : 20)
            .animation(.easeInOut(duration: 0.6).delay(0.7), value: showSearch)
            
            // Аватар и уровень пользователя
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    Text(String(user.name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Уровень \(user.profile.level)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("\(user.profile.statistics.experiencePoints) XP")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Прогресс-бар уровня
                    ProgressView(value: Double(user.profile.statistics.experiencePoints % 100), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 4)
                }
                
                Spacer()
            }
            .opacity(showGreeting ? 1 : 0)
            .animation(.easeInOut(duration: 0.6).delay(0.9), value: showGreeting)
        }
        .onAppear {
            showGreeting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showSearch = true
            }
        }
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

// MARK: - Enhanced Quick Actions
struct EnhancedQuickActions: View {
    @Binding var selectedTab: Int
    var animation: Namespace.ID
    @State private var showActions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Быстрые действия")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(HomeSection.allCases.enumerated()), id: \.element) { index, section in
                    EnhancedQuickActionCard(
                        section: section,
                        isSelected: selectedTab == index,
                        animation: animation
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    }
                }
            }
        }
        .opacity(showActions ? 1 : 0)
        .offset(y: showActions ? 0 : 30)
        .animation(.easeInOut(duration: 0.8).delay(1.0), value: showActions)
        .onAppear { showActions = true }
    }
}

struct EnhancedQuickActionCard: View {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
                action()
            }
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: section.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: section.gradientColors[0].opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: section.icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(section.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(section.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .matchedGeometryEffect(id: "section_\(section.title)", in: animation)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Animated Stats Section
struct AnimatedStatsSection: View {
    let user: User
    @State private var showStats = false
    @State private var animateNumbers = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Твоя активность")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                AnimatedStatCard(
                    title: "Найдено",
                    value: user.profile.statistics.foundItemsCount,
                    icon: "checkmark.circle.fill",
                    color: .green,
                    animateNumbers: animateNumbers
                )
                
                AnimatedStatCard(
                    title: "События",
                    value: user.profile.statistics.eventsAttended,
                    icon: "calendar.badge.plus",
                    color: .blue,
                    animateNumbers: animateNumbers
                )
                
                AnimatedStatCard(
                    title: "Посты",
                    value: user.profile.statistics.postsCount,
                    icon: "doc.text.fill",
                    color: .purple,
                    animateNumbers: animateNumbers
                )
            }
        }
        .opacity(showStats ? 1 : 0)
        .offset(y: showStats ? 0 : 30)
        .animation(.easeInOut(duration: 0.8).delay(1.3), value: showStats)
        .onAppear {
            showStats = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                animateNumbers = true
            }
        }
    }
}

struct AnimatedStatCard: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    let animateNumbers: Bool
    @State private var animatedValue = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(animatedValue)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .onChange(of: animateNumbers) { _ in
                    withAnimation(.easeOut(duration: 1.0)) {
                        animatedValue = value
                    }
                }
            
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

// MARK: - Upcoming Events Section
struct UpcomingEventsSection: View {
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
                    // Навигация к событиям через TabView
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .fontWeight(.medium)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<min(3, Event.mockEvents.count), id: \.self) { index in
                        Button(action: {
                            // Навигация к деталям события
                        }) {
                            EnhancedEventCard(event: Event.mockEvents[index])
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .opacity(showEvents ? 1 : 0)
        .offset(y: showEvents ? 0 : 30)
        .animation(.easeInOut(duration: 0.8).delay(1.6), value: showEvents)
        .onAppear { showEvents = true }
    }
}

struct EnhancedEventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: event.category.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: event.category.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(event.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 160)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
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
                    // Навигация к lost & found через TabView
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .fontWeight(.medium)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<min(3, LostFoundItem.mockItems.count), id: \.self) { index in
                        Button(action: {
                            // Навигация к деталям предмета
                        }) {
                            EnhancedItemCard(item: LostFoundItem.mockItems[index])
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .opacity(showItems ? 1 : 0)
        .offset(y: showItems ? 0 : 30)
        .animation(.easeInOut(duration: 0.8).delay(1.9), value: showItems)
        .onAppear { showItems = true }
    }
}

struct EnhancedItemCard: View {
    let item: LostFoundItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [item.category.color, item.category.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: item.category.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(item.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text(item.status.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
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
        .frame(width: 160)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Community Activity Section
struct CommunityActivitySection: View {
    @State private var showActivity = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Активность сообщества")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(0..<min(3, ActivityItem.mockActivityItems.count), id: \.self) { index in
                    HomeActivityRow(activity: ActivityItem.mockActivityItems[index])
                }
            }
        }
        .opacity(showActivity ? 1 : 0)
        .offset(y: showActivity ? 0 : 30)
        .animation(.easeInOut(duration: 0.8).delay(2.2), value: showActivity)
        .onAppear { showActivity = true }
    }
}

struct HomeActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(activity.type.color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: activity.type.icon)
                    .font(.title3)
                    .foregroundColor(activity.type.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(activity.date.formatted(.relative(presentation: .named)))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Enhanced Floating Action Button
struct EnhancedFloatingActionButton: View {
    @Binding var showingQuickActions: Bool
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                        showingQuickActions.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                            .frame(width: 60, height: 60)
                            .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                        
                        Image(systemName: showingQuickActions ? "xmark" : "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(showingQuickActions ? 90 : 0))
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingQuickActions)
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
    
    var subtitle: String {
        switch self {
        case .lostFound: return "Найти вещи"
        case .events: return "Участвовать"
        case .profile: return "Личный кабинет"
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