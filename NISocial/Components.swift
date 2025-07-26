import SwiftUI

// MARK: - Custom Components

struct GradientButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let action: () -> Void
    
    init(title: String, icon: String, colors: [Color], action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.gradient = LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(20)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// struct CategoryChip: View {
//     let category: ItemCategory
//     let isSelected: Bool
//     let action: () -> Void
//     
//     var body: some View {
//         Button(action: action) {
//             HStack(spacing: 8) {
//                 Image(systemName: category.icon)
//                     .font(.caption)
//                     .fontWeight(.semibold)
//                 
//                 Text(category.rawValue)
//                     .font(.caption)
//                     .fontWeight(.medium)
//             }
//             .foregroundColor(isSelected ? .white : category.color)
//             .padding(.horizontal, 12)
//             .padding(.vertical, 8)
//             .background(
//                 RoundedRectangle(cornerRadius: 20)
//                     .fill(isSelected ? category.color : category.color.opacity(0.1))
//             )
//         }
//         .buttonStyle(PlainButtonStyle())
//     }
// }

// struct EventCategoryChip: View {
//     let category: EventCategory
//     let isSelected: Bool
//     let action: () -> Void
//     
//     var body: some View {
//         Button(action: action) {
//             HStack(spacing: 8) {
//                 Image(systemName: category.icon)
//                     .font(.caption)
//                     .fontWeight(.semibold)
//                 
//                 Text(category.rawValue)
//                     .font(.caption)
//                     .fontWeight(.medium)
//             }
//             .foregroundColor(isSelected ? .white : category.color)
//             .padding(.horizontal, 12)
//             .padding(.vertical, 8)
//             .background(
//                 RoundedRectangle(cornerRadius: 20)
//                     .fill(isSelected ? category.color : category.color.opacity(0.1))
//             )
//         }
//         .buttonStyle(PlainButtonStyle())
//     }
// }

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16, weight: .medium))
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

// struct StatusBadge: View {
//     let status: ItemStatus
//     
//     var body: some View {
//         Text(status.rawValue)
//             .font(.caption2)
//             .fontWeight(.semibold)
//             .foregroundColor(.white)
//             .padding(.horizontal, 8)
//             .padding(.vertical, 4)
//             .background(
//                 Capsule()
//                     .fill(status.color)
//             )
//     }
// }

// struct EventStatusBadge: View {
//     let status: EventStatus
//     
//     var body: some View {
//         Text(status.rawValue)
//             .font(.caption2)
//             .fontWeight(.semibold)
//             .foregroundColor(.white)
//             .padding(.horizontal, 8)
//             .padding(.vertical, 4)
//             .background(
//                 Capsule()
//                     .fill(status.color)
//             )
//     }
// }

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(40)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Загрузка...")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Custom Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
    }
}

struct GlassmorphismStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func glassmorphismStyle() -> some View {
        modifier(GlassmorphismStyle())
    }
}

// MARK: - Animations

struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

extension View {
    func pulseAnimation() -> some View {
        modifier(PulseAnimation())
    }
}

// MARK: - Filter Components

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var animation: Namespace.ID
    @State private var scale = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                scale = false
            }
            action()
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            isSelected ?
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .matchedGeometryEffect(id: "filter_\(title)", in: animation)
                )
                .scaleEffect(scale ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Profile Components

struct ProfileAvatar: View {
    let size: CGFloat
    let imageURL: String?
    let initials: String
    
    init(size: CGFloat = 80, imageURL: String? = nil, name: String) {
        self.size = size
        self.imageURL = imageURL
        self.initials = String(name.prefix(2)).uppercased()
    }
    
    var body: some View {
        ZStack {
            if let imageURL = imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    placeholderView
                }
            } else {
                placeholderView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var placeholderView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(initials)
                .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// struct AchievementCard: View {
//     let achievement: Achievement
//     
//     var body: some View {
//         HStack(spacing: 12) {
//             ZStack {
//                 Circle()
//                     .fill(achievement.type.color.opacity(0.1))
//                     .frame(width: 50, height: 50)
//                 
//                 Image(systemName: achievement.icon)
//                     .font(.title2)
//                     .foregroundColor(achievement.type.color)
//             }
//             
//             VStack(alignment: .leading, spacing: 4) {
//                 Text(achievement.title)
//                     .font(.headline)
//                     .fontWeight(.semibold)
//                     .foregroundColor(.primary)
//                 
//                 Text(achievement.description)
//                     .font(.caption)
//                     .foregroundColor(.secondary)
//                     .lineLimit(2)
//                 
//                 Text(achievement.dateEarned.formatted(date: .abbreviated, time: .omitted))
//                     .font(.caption2)
//                     .foregroundColor(.secondary)
//             }
//             
//             Spacer()
//         }
//         .padding(16)
//         .background(
//             RoundedRectangle(cornerRadius: 16)
//                 .fill(Color.white)
//                 .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
//         )
//     }
// }

struct ProfileSettingsRow: View {
    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    init(title: String, subtitle: String? = nil, icon: String, iconColor: Color = .blue, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProfileSectionHeader: View {
    let title: String
    let action: (() -> Void)?
    
    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            if let action = action {
                Button("Показать все", action: action)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
} 