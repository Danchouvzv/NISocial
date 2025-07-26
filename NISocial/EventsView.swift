import SwiftUI

struct EventsView: View {
    @State private var searchText = ""
    @State private var selectedCategory: EventCategory? = nil
    @State private var selectedStatus: EventStatus? = nil
    @State private var showingAddEvent = false
    @State private var showingFilters = false
    @State private var isSearchFocused = false
    @State private var selectedEvent: Event? = nil
    @State private var animateCards = false
    @Namespace private var animation
    
    var filteredEvents: [Event] {
        var events = Event.mockEvents
        
        if !searchText.isEmpty {
            events = events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        if let category = selectedCategory {
            events = events.filter { $0.category == category }
        }
        
        if let status = selectedStatus {
            events = events.filter { $0.status == status }
        }
        
        return events
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Динамический градиентный фон
                AnimatedEventsBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Креативный хедер
                    CreativeEventsHeader(
                        searchText: $searchText,
                        isSearchFocused: $isSearchFocused,
                        showingFilters: $showingFilters,
                        animation: animation
                    )
                    
                    // Интерактивные фильтры
                    InteractiveFiltersSection(
                        selectedCategory: $selectedCategory,
                        selectedStatus: $selectedStatus,
                        animation: animation
                    )
                    
                    // Контент событий
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(filteredEvents.enumerated()), id: \.element.id) { index, event in
                                CreativeEventCard(
                                    event: event,
                                    index: index,
                                    animateCards: animateCards,
                                    animation: animation
                                )
                                .onTapGesture {
                                    selectedEvent = event
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                
                // FAB кнопка добавления
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddEvent = true }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                    )
                                
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        .scaleEffect(showingAddEvent ? 1.1 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showingAddEvent)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView()
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
    }
}

// MARK: - Animated Events Background
struct AnimatedEventsBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Основной градиент
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.1),
                    Color.pink.opacity(0.08),
                    Color.blue.opacity(0.05),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Анимированные круги
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.15), .pink.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 180)
                .offset(x: animate ? -60 : -100, y: animate ? -80 : -40)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.pink.opacity(0.1), .blue.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .offset(x: animate ? 80 : 40, y: animate ? 60 : 100)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear { animate = true }
    }
}

// MARK: - Creative Events Header
struct CreativeEventsHeader: View {
    @Binding var searchText: String
    @Binding var isSearchFocused: Bool
    @Binding var showingFilters: Bool
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 16) {
            // Заголовок с анимацией
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("События")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Найди что-то интересное")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Кнопка фильтров
                Button(action: { showingFilters.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "slider.horizontal.3")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }
                .matchedGeometryEffect(id: "filterButton", in: animation)
            }
            
            // Поисковая строка
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    TextField("Поиск событий...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isSearchFocused = true
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                )
                .scaleEffect(isSearchFocused ? 1.02 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearchFocused)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Interactive Filters Section
struct InteractiveFiltersSection: View {
    @Binding var selectedCategory: EventCategory?
    @Binding var selectedStatus: EventStatus?
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 16) {
            // Категории
            VStack(alignment: .leading, spacing: 12) {
                Text("Категории")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "Все",
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil },
                            animation: animation
                        )
                        
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            FilterChip(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category },
                                animation: animation
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            // Статусы
            VStack(alignment: .leading, spacing: 12) {
                Text("Статус")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "Все",
                            isSelected: selectedStatus == nil,
                            action: { selectedStatus = nil },
                            animation: animation
                        )
                        
                        ForEach(EventStatus.allCases, id: \.self) { status in
                            FilterChip(
                                title: status.rawValue,
                                isSelected: selectedStatus == status,
                                action: { selectedStatus = status },
                                animation: animation
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.vertical, 16)
    }
}



// MARK: - Creative Event Card
struct CreativeEventCard: View {
    let event: Event
    let index: Int
    let animateCards: Bool
    var animation: Namespace.ID
    @State private var isLiked = false
    @State private var isRegistered = false
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Изображение события
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: event.category.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .overlay(
                        VStack {
                            Image(systemName: event.category.icon)
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(event.category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    )
                
                // Статус события
                VStack(spacing: 8) {
                    StatusBadge(status: event.status)
                    
                    Spacer()
                    
                    // Кнопки действий
                    HStack(spacing: 12) {
                        Button(action: { isLiked.toggle() }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(isLiked ? .red : .white)
                            }
                        }
                        
                        Button(action: { isRegistered.toggle() }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: isRegistered ? "checkmark.circle.fill" : "plus.circle")
                                    .font(.title3)
                                    .foregroundColor(isRegistered ? .green : .white)
                            }
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
            
            // Информация о событии
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(event.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                // Детали события
                VStack(spacing: 8) {
                    EventDetailRow(
                        icon: "calendar",
                        text: event.date.formatted(date: .abbreviated, time: .shortened),
                        color: .blue
                    )
                    
                    EventDetailRow(
                        icon: "location",
                        text: event.location,
                        color: .green
                    )
                    
                    EventDetailRow(
                        icon: "person.2",
                        text: "\(event.currentParticipants)/\(event.maxParticipants) участников",
                        color: .orange
                    )
                }
                
                // Теги
                if !event.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(event.tags.prefix(3), id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(.purple.opacity(0.1))
                                    )
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
        )
        .scaleEffect(animateCards ? 1.0 : 0.8)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateCards)
        .onTapGesture {
            withAnimation(.spring()) {
                showDetails = true
            }
        }
    }
}

struct StatusBadge: View {
    let status: EventStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(status.color)
            )
            .padding(.top, 16)
            .padding(.trailing, 16)
    }
}

struct EventDetailRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 16)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Add Event View
struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: EventCategory = .academic
    @State private var selectedDate = Date()
    @State private var location = ""
    @State private var maxParticipants = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Создать событие")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Заголовок
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Название")
                                .font(.headline)
                            TextField("Введите название события", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Описание
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Описание")
                                .font(.headline)
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Категория
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Категория")
                                .font(.headline)
                            Picker("Категория", selection: $selectedCategory) {
                                ForEach(EventCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Дата и время
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Дата и время")
                                .font(.headline)
                            DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Место
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Место")
                                .font(.headline)
                            TextField("Введите место проведения", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Максимум участников
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Максимум участников")
                                .font(.headline)
                            TextField("Количество", text: $maxParticipants)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Новое событие")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Создать") {
                        // Здесь будет логика создания события
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Event Detail View
struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    @State private var isRegistered = false
    @State private var isLiked = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Изображение события
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: event.category.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 250)
                            .overlay(
                                VStack {
                                    Image(systemName: event.category.icon)
                                        .font(.system(size: 64, weight: .light))
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text(event.category.rawValue)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            )
                        
                        StatusBadge(status: event.status)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Заголовок и описание
                        VStack(alignment: .leading, spacing: 12) {
                            Text(event.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(event.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // Детали события
                        VStack(spacing: 16) {
                            EventDetailRow(
                                icon: "calendar",
                                text: event.date.formatted(date: .abbreviated, time: .shortened),
                                color: .blue
                            )
                            
                            EventDetailRow(
                                icon: "location",
                                text: event.location,
                                color: .green
                            )
                            
                            EventDetailRow(
                                icon: "person.2",
                                text: "\(event.currentParticipants)/\(event.maxParticipants) участников",
                                color: .orange
                            )
                            
                            EventDetailRow(
                                icon: "person.circle",
                                text: "Организатор: \(event.organizer)",
                                color: .purple
                            )
                        }
                        
                        // Теги
                        if !event.tags.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Теги")
                                    .font(.headline)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(event.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .font(.caption)
                                            .foregroundColor(.purple)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(.purple.opacity(0.1))
                                            )
                                    }
                                }
                            }
                        }
                        
                        // Кнопки действий
                        HStack(spacing: 16) {
                            Button(action: { isLiked.toggle() }) {
                                HStack {
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                    Text(isLiked ? "Нравится" : "Лайк")
                                }
                                .font(.headline)
                                .foregroundColor(isLiked ? .red : .primary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isLiked ? Color.red : Color.gray.opacity(0.3), lineWidth: 2)
                                )
                            }
                            
                            Button(action: { isRegistered.toggle() }) {
                                HStack {
                                    Image(systemName: isRegistered ? "checkmark.circle.fill" : "plus.circle")
                                    Text(isRegistered ? "Зарегистрирован" : "Участвовать")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple, .pink],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EventsView()
} 