import Foundation
import SwiftUI

// MARK: - Lost & Found Models

struct LostFoundItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var category: ItemCategory
    var location: String
    var date: Date
    var contactInfo: String
    var imageURL: String?
    var status: ItemStatus
    var type: ItemType // lost or found
    var reward: String?
    var tags: [String]
    
    init(title: String, description: String, category: ItemCategory, location: String, contactInfo: String, type: ItemType, imageURL: String? = nil, reward: String? = nil, tags: [String] = []) {
        self.title = title
        self.description = description
        self.category = category
        self.location = location
        self.date = Date()
        self.contactInfo = contactInfo
        self.imageURL = imageURL
        self.status = .active
        self.type = type
        self.reward = reward
        self.tags = tags
    }
}

enum ItemCategory: String, CaseIterable, Codable {
    case electronics = "Электроника"
    case clothing = "Одежда"
    case books = "Книги"
    case accessories = "Аксессуары"
    case documents = "Документы"
    case sports = "Спорт"
    case other = "Другое"
    
    var icon: String {
        switch self {
        case .electronics: return "iphone"
        case .clothing: return "tshirt"
        case .books: return "book"
        case .accessories: return "bag"
        case .documents: return "doc.text"
        case .sports: return "sportscourt"
        case .other: return "questionmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .electronics: return .blue
        case .clothing: return .purple
        case .books: return .orange
        case .accessories: return .green
        case .documents: return .red
        case .sports: return .yellow
        case .other: return .gray
        }
    }
}

enum ItemStatus: String, CaseIterable, Codable {
    case active = "Активно"
    case resolved = "Решено"
    case expired = "Истекло"
    
    var color: Color {
        switch self {
        case .active: return .green
        case .resolved: return .blue
        case .expired: return .gray
        }
    }
}

enum ItemType: String, CaseIterable, Codable {
    case lost = "Потеряно"
    case found = "Найдено"
    
    var icon: String {
        switch self {
        case .lost: return "magnifyingglass"
        case .found: return "hand.raised.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .lost: return .red
        case .found: return .green
        }
    }
}

// MARK: - Events Models

struct Event: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date
    var location: String
    var category: EventCategory
    var organizer: String
    var imageURL: String?
    var status: EventStatus
    var maxParticipants: Int?
    var currentParticipants: Int
    var tags: [String]
    var isRegistrationRequired: Bool
    
    init(title: String, description: String, date: Date, location: String, category: EventCategory, organizer: String, imageURL: String? = nil, maxParticipants: Int? = nil, tags: [String] = [], isRegistrationRequired: Bool = false) {
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.category = category
        self.organizer = organizer
        self.imageURL = imageURL
        self.status = .upcoming
        self.maxParticipants = maxParticipants
        self.currentParticipants = 0
        self.tags = tags
        self.isRegistrationRequired = isRegistrationRequired
    }
}

enum EventCategory: String, CaseIterable, Codable {
    case academic = "Академическое"
    case sports = "Спортивное"
    case cultural = "Культурное"
    case social = "Социальное"
    case technical = "Техническое"
    case other = "Другое"
    
    var icon: String {
        switch self {
        case .academic: return "graduationcap"
        case .sports: return "sportscourt"
        case .cultural: return "music.note"
        case .social: return "person.3"
        case .technical: return "laptopcomputer"
        case .other: return "star"
        }
    }
    
    var color: Color {
        switch self {
        case .academic: return .blue
        case .sports: return .green
        case .cultural: return .purple
        case .social: return .orange
        case .technical: return .red
        case .other: return .gray
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .academic: return [.blue, .cyan]
        case .sports: return [.green, .mint]
        case .cultural: return [.purple, .pink]
        case .social: return [.orange, .yellow]
        case .technical: return [.red, .orange]
        case .other: return [.gray, .blue]
        }
    }
}

enum EventStatus: String, CaseIterable, Codable {
    case upcoming = "Предстоящее"
    case ongoing = "Проходит"
    case completed = "Завершено"
    case cancelled = "Отменено"
    
    var color: Color {
        switch self {
        case .upcoming: return .blue
        case .ongoing: return .green
        case .completed: return .gray
        case .cancelled: return .red
        }
    }
}

// MARK: - User Models

struct User: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var grade: String
    var avatarURL: String?
    var notificationsEnabled: Bool
    var createdItems: [LostFoundItem]
    var registeredEvents: [Event]
    var profile: UserProfile
    
    init(name: String, email: String, grade: String, avatarURL: String? = nil) {
        self.name = name
        self.email = email
        self.grade = grade
        self.avatarURL = avatarURL
        self.notificationsEnabled = true
        self.createdItems = []
        self.registeredEvents = []
        self.profile = UserProfile()
    }
}

struct UserProfile: Codable {
    var bio: String
    var phoneNumber: String
    var dateOfBirth: Date
    var joinDate: Date
    var achievements: [Achievement]
    var statistics: UserStatistics
    var preferences: UserPreferences
    var recentActivity: [ActivityItem]
    var level: Int
    
    init() {
        self.bio = "Студент NIS HBN"
        self.phoneNumber = "+7 777 123 45 67"
        self.dateOfBirth = Calendar.current.date(byAdding: .year, value: -16, to: Date()) ?? Date()
        self.joinDate = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
        self.achievements = Achievement.mockAchievements
        self.statistics = UserStatistics()
        self.preferences = UserPreferences()
        self.recentActivity = ActivityItem.mockActivityItems
        self.level = 5
    }
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var icon: String
    var dateEarned: Date
    var type: AchievementType
    var isUnlocked: Bool
    
    enum AchievementType: String, Codable, CaseIterable {
        case firstItem = "Первый пост"
        case helpful = "Помощник"
        case active = "Активный участник"
        case organizer = "Организатор"
        case perfect = "Отличник"
        
        var color: Color {
            switch self {
            case .firstItem: return .blue
            case .helpful: return .green
            case .active: return .orange
            case .organizer: return .purple
            case .perfect: return .yellow
            }
        }
    }
}

struct UserStatistics: Codable {
    var itemsPosted: Int
    var itemsFound: Int
    var eventsCreated: Int
    var eventsAttended: Int
    var helpfulRatings: Int
    var daysActive: Int
    var postsCount: Int
    var foundItemsCount: Int
    var likesCount: Int
    var experiencePoints: Int
    
    init() {
        self.itemsPosted = 12
        self.itemsFound = 8
        self.eventsCreated = 3
        self.eventsAttended = 15
        self.helpfulRatings = 24
        self.daysActive = 180
        self.postsCount = 12
        self.foundItemsCount = 8
        self.likesCount = 156
        self.experiencePoints = 75
    }
}

struct UserPreferences: Codable {
    var theme: AppTheme
    var language: Language
    var privacyLevel: PrivacyLevel
    var notificationTypes: Set<NotificationType>
    
    enum AppTheme: String, Codable, CaseIterable {
        case light = "Светлая"
        case dark = "Темная"
        case auto = "Авто"
    }
    
    enum Language: String, Codable, CaseIterable {
        case kazakh = "Қазақша"
        case russian = "Русский"
        case english = "English"
    }
    
    enum PrivacyLevel: String, Codable, CaseIterable {
        case `public` = "Публичный"
        case friends = "Друзья"
        case `private` = "Приватный"
    }
    
    enum NotificationType: String, Codable, CaseIterable {
        case newItems = "Новые объявления"
        case events = "События"
        case matches = "Совпадения"
        case achievements = "Достижения"
        case system = "Системные"
    }
    
    init() {
        self.theme = .auto
        self.language = .russian
        self.privacyLevel = .friends
        self.notificationTypes = [.newItems, .events, .matches, .achievements]
    }
}

// MARK: - Mock Data

extension LostFoundItem {
    static let mockItems: [LostFoundItem] = [
        LostFoundItem(
            title: "Потерян iPhone 15",
            description: "Черный iPhone 15 с синим чехлом. Потерян в столовой во время обеда.",
            category: .electronics,
            location: "Столовая",
            contactInfo: "+7 777 123 45 67",
            type: .lost,
            reward: "5000 тенге",
            tags: ["телефон", "iphone", "столовая"]
        ),
        LostFoundItem(
            title: "Найдена черная сумка",
            description: "Черная кожаная сумка найдена в библиотеке. Внутри учебники по математике.",
            category: .accessories,
            location: "Библиотека",
            contactInfo: "+7 777 987 65 43",
            type: .found,
            tags: ["сумка", "библиотека", "учебники"]
        ),
        LostFoundItem(
            title: "Потеряны ключи",
            description: "Связка ключей с брелком в виде медвежонка. Потеряны на территории школы.",
            category: .accessories,
            location: "Территория школы",
            contactInfo: "+7 777 555 44 33",
            type: .lost,
            tags: ["ключи", "брелок", "медвежонок"]
        )
    ]
}

extension Event {
    static let mockEvents: [Event] = [
        Event(
            title: "День открытых дверей",
            description: "Приглашаем всех желающих познакомиться с нашей школой. Экскурсии, мастер-классы, встречи с учителями.",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            location: "Актовый зал",
            category: .academic,
            organizer: "Администрация школы",
            maxParticipants: 200,
            tags: ["день открытых дверей", "экскурсия", "мастер-класс"],
            isRegistrationRequired: true
        ),
        Event(
            title: "Школьный турнир по баскетболу",
            description: "Ежегодный турнир между классами. Призы для победителей!",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            location: "Спортивный зал",
            category: .sports,
            organizer: "Учитель физкультуры",
            maxParticipants: 80,
            tags: ["баскетбол", "турнир", "спорт"],
            isRegistrationRequired: true
        ),
        Event(
            title: "Концерт талантов",
            description: "Покажите свои таланты! Музыка, танцы, стихи - все приветствуется.",
            date: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
            location: "Актовый зал",
            category: .cultural,
            organizer: "Культурный комитет",
            tags: ["концерт", "таланты", "творчество"],
            isRegistrationRequired: false
        )
    ]
}

// MARK: - Activity Models

struct ActivityItem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let type: ActivityType
    
    init(title: String, description: String, date: Date, type: ActivityType) {
        self.title = title
        self.description = description
        self.date = date
        self.type = type
    }
}

enum ActivityType: String, CaseIterable, Codable {
    case post = "Пост"
    case found = "Найдено"
    case event = "Событие"
    case achievement = "Достижение"
    
    var icon: String {
        switch self {
        case .post: return "doc.text.fill"
        case .found: return "checkmark.circle.fill"
        case .event: return "calendar.badge.plus"
        case .achievement: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .post: return .blue
        case .found: return .green
        case .event: return .purple
        case .achievement: return .yellow
        }
    }
}

extension User {
    static let mockUser = User(
        name: "Алихан Талгатов",
        email: "alikhan.talgatov@nis.edu.kz",
        grade: "11 класс"
    )
}

extension Achievement {
    static let mockAchievements: [Achievement] = [
        Achievement(
            title: "Первый пост",
            description: "Создал первое объявление",
            icon: "plus.circle.fill",
            dateEarned: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            type: .firstItem,
            isUnlocked: true
        ),
        Achievement(
            title: "Помощник",
            description: "Помог найти 5 вещей",
            icon: "hand.raised.fill",
            dateEarned: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
            type: .helpful,
            isUnlocked: true
        ),
        Achievement(
            title: "Активный участник",
            description: "Посетил 10 событий",
            icon: "star.fill",
            dateEarned: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            type: .active,
            isUnlocked: false
        )
    ]
}

extension ActivityItem {
    static let mockActivityItems: [ActivityItem] = [
        ActivityItem(
            title: "Опубликовал объявление",
            description: "Потерян телефон в столовой",
            date: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
            type: .post
        ),
        ActivityItem(
            title: "Помог найти вещь",
            description: "Найден ключ от шкафчика",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            type: .found
        ),
        ActivityItem(
            title: "Создал событие",
            description: "Встреча клуба программистов",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            type: .event
        ),
        ActivityItem(
            title: "Получил достижение",
            description: "Помощник - помог найти 5 вещей",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            type: .achievement
        ),
        ActivityItem(
            title: "Посетил событие",
            description: "Школьный турнир по баскетболу",
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            type: .event
        )
    ]
}