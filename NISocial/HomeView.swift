import SwiftUI
import Foundation // Для моделей

struct HomeView: View {
    @State private var showAddSheet = false
    let user = User.mockUser
    @Namespace private var animation
    
    var body: some View {
        NavigationView {
            ZStack {
                // ВАУ-Градиентный фон с blobs
                AnimatedBlobsBackground()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Стеклянная карточка профиля
                        GlassProfileCard(user: user)
                            .padding(.top, 24)
                            .padding(.horizontal, 8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        
                        // Мотивационный баннер
                        MotivationalBanner()
                            .padding(.horizontal, 8)
                        
                        // Креативные плитки разделов
                        HStack(spacing: 20) {
                            SectionTile(icon: "magnifyingglass", label: "Lost&Found", color: .blue, gradient: [.blue, .cyan], animation: animation)
                            SectionTile(icon: "calendar", label: "События", color: .purple, gradient: [.purple, .pink], animation: animation)
                            SectionTile(icon: "person.fill", label: "Профиль", color: .green, gradient: [.green, .mint], animation: animation)
                        }
                        .padding(.horizontal, 8)
                        
                        // Лента событий/потерь
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Что нового?")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.leading, 8)
                            ForEach(Event.mockEvents.prefix(2), id: \.id) { event in
                                HomeEventCard(event: event)
                                    .transition(.opacity.combined(with: .move(edge: .leading)))
                            }
                            ForEach(LostFoundItem.mockItems.prefix(2), id: \.id) { item in
                                HomeLostFoundCard(item: item)
                                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 100)
                }
                
                // FAB-кнопка
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddSheet = true }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 68, height: 68)
                                    .shadow(color: .purple.opacity(0.25), radius: 16, x: 0, y: 8)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                    )
                                Image(systemName: "plus")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.trailing, 28)
                        .padding(.bottom, 24)
                        .scaleEffect(showAddSheet ? 1.1 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showAddSheet)
                        .accessibilityLabel("Добавить объявление или событие")
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showAddSheet) {
            Text("Добавить объявление или событие")
                .font(.title2)
                .padding()
        }
    }
}

// --- ВАУ-Градиентный фон с blobs ---
struct AnimatedBlobsBackground: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(colors: [.blue.opacity(0.25), .purple.opacity(0.18)], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 320, height: 320)
                .offset(x: animate ? -80 : -40, y: animate ? -120 : -60)
                .blur(radius: 60)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            Circle()
                .fill(
                    LinearGradient(colors: [.cyan.opacity(0.18), .mint.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 220, height: 220)
                .offset(x: animate ? 120 : 80, y: animate ? 100 : 60)
                .blur(radius: 60)
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: animate)
            Circle()
                .fill(
                    LinearGradient(colors: [.orange.opacity(0.13), .pink.opacity(0.10)], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 180, height: 180)
                .offset(x: animate ? 60 : 100, y: animate ? -80 : -40)
                .blur(radius: 60)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear { animate = true }
    }
}

// --- Стеклянная карточка профиля ---
struct GlassProfileCard: View {
    let user: User
    @State private var pulse = false
    var body: some View {
        ZStack {
            // Glassmorphism background
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(LinearGradient(colors: [.blue.opacity(0.18), .purple.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                )
                .shadow(color: .blue.opacity(0.08), radius: 16, x: 0, y: 8)
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: .purple.opacity(0.18), radius: 8, x: 0, y: 4)
                        .scaleEffect(pulse ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                    Text(String(user.name.prefix(2)))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .onAppear { pulse = true }
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("NIS HBN • 11 класс")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Будь активным! Помогай, участвуй, вдохновляйся.")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }
}

// --- Креативная плитка раздела ---
struct SectionTile: View {
    let icon: String
    let label: String
    let color: Color
    let gradient: [Color]
    var animation: Namespace.ID
    @State private var isPressed = false
    var body: some View {
        Button(action: { withAnimation(.spring()) { isPressed.toggle(); DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { isPressed = false } } }) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 56, height: 56)
                        .shadow(color: color.opacity(0.18), radius: 8, x: 0, y: 4)
                        .scaleEffect(isPressed ? 0.93 : 1.0)
                        .matchedGeometryEffect(id: label, in: animation)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .frame(width: 80)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// --- Мотивационный баннер ---
struct MotivationalBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundColor(.yellow)
            VStack(alignment: .leading, spacing: 2) {
                Text("Каждый день — шанс стать лучше!")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("Помоги кому-то сегодня или участвуй в событии!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(LinearGradient(colors: [.yellow.opacity(0.13), .blue.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .shadow(color: .yellow.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// --- Карточка события ---
struct HomeEventCard: View {
    let event: Event
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple.opacity(0.08))
                    .frame(width: 48, height: 48)
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.purple)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(event.location)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
}

// --- Карточка потерянной/найденной вещи ---
struct HomeLostFoundCard: View {
    let item: LostFoundItem
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.08))
                    .frame(width: 48, height: 48)
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(item.date, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item.location)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    HomeView()
} 