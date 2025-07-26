import SwiftUI

struct LostFoundView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ItemCategory? = nil
    @State private var selectedStatus: ItemStatus? = nil
    @State private var selectedType: ItemType? = nil
    @State private var showingAddItem = false
    @State private var showingFilters = false
    @State private var isSearchFocused = false
    @Namespace private var animation
    
    var filteredItems: [LostFoundItem] {
        var items = LostFoundItem.mockItems
        
        if !searchText.isEmpty {
            items = items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText) ||
                item.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        
        if let status = selectedStatus {
            items = items.filter { $0.status == status }
        }
        
        if let type = selectedType {
            items = items.filter { $0.type == type }
        }
        
        return items
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон
                LinearGradient(
                    colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.05), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Креативный хедер
                    CreativeHeader()
                    
                    // Поисковая строка с вау-эффектом
                    SearchBarView(
                        text: $searchText,
                        isFocused: $isSearchFocused,
                        animation: animation
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Фильтры
                    FilterSection(
                        selectedCategory: $selectedCategory,
                        selectedStatus: $selectedStatus,
                        selectedType: $selectedType,
                        animation: animation
                    )
                    .padding(.top, 16)
                    
                    // Статистика
                    if !searchText.isEmpty || selectedCategory != nil || selectedStatus != nil || selectedType != nil {
                        ResultsStatsView(count: filteredItems.count)
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                    }
                    
                    // Список элементов
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredItems, id: \.id) { item in
                                ModernItemCard(item: item, animation: animation)
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
                
                // FAB кнопка
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddItem = true }) {
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
                                
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        .scaleEffect(showingAddItem ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddItem)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
    }
}

// MARK: - Creative Header
struct CreativeHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Lost & Found")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Найди то, что потерял, или помоги найти")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Статистика
            HStack(spacing: 16) {
                StatBadge(value: "24", label: "активных", color: .green)
                StatBadge(value: "156", label: "найдено", color: .blue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

struct StatBadge: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Search Bar
struct SearchBarView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Поиск по названию, описанию, тегам...", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isFocused = true
                        }
                    }
                
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
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isFocused ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
    }
}

// MARK: - Filter Section
struct FilterSection: View {
    @Binding var selectedCategory: ItemCategory?
    @Binding var selectedStatus: ItemStatus?
    @Binding var selectedType: ItemType?
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Тип (Потеряно/Найдено)
                ForEach(ItemType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue,
                        isSelected: selectedType == type,
                        action: {
                            withAnimation(.spring()) {
                                selectedType = selectedType == type ? nil : type
                            }
                        },
                        animation: animation
                    )
                }
                
                Divider()
                    .frame(height: 20)
                    .padding(.horizontal, 4)
                
                // Категории
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: {
                            withAnimation(.spring()) {
                                selectedCategory = selectedCategory == category ? nil : category
                            }
                        },
                        animation: animation
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}



// MARK: - Results Stats
struct ResultsStatsView: View {
    let count: Int
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text.magnifyingglass")
                .foregroundColor(.blue)
                .font(.caption)
            
            Text("Найдено \(count) объявлений")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Modern Item Card
struct ModernItemCard: View {
    let item: LostFoundItem
    var animation: Namespace.ID
    @State private var isLiked = false
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header с типом и статусом
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: item.type.icon)
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Text(item.type.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(item.type.color)
                    )
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(item.status.color)
                            .frame(width: 8, height: 8)
                        
                        Text(item.status.rawValue)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Заголовок
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // Описание
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                // Теги
                if !item.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(item.tags.prefix(3), id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.blue.opacity(0.1))
                                    )
                            }
                        }
                    }
                }
                
                // Footer
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text(item.location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: { isLiked.toggle() }) {
                            HStack(spacing: 4) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.caption)
                                    .foregroundColor(isLiked ? .red : .secondary)
                                
                                Text("12")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Image(systemName: "message")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("3")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text(item.date, style: .relative)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(item.category.color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            ItemDetailView(item: item)
        }
    }
}

// MARK: - Add Item View
struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: ItemCategory = .other
    @State private var selectedType: ItemType = .lost
    @State private var location = ""
    @State private var contactInfo = ""
    @State private var reward = ""
    @State private var tags = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Тип объявления
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Тип объявления")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 12) {
                            ForEach(ItemType.allCases, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: type.icon)
                                        Text(type.rawValue)
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedType == type ? .white : type.color)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedType == type ? type.color : type.color.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    // Основная информация
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Основная информация")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 16) {
                            CustomTextField(title: "Название", text: $title, placeholder: "Краткое описание")
                            CustomTextField(title: "Описание", text: $description, placeholder: "Подробное описание", isMultiline: true)
                            
                            // Категория
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Категория")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Picker("Категория", selection: $selectedCategory) {
                                    ForEach(ItemCategory.allCases, id: \.self) { category in
                                        HStack {
                                            Image(systemName: category.icon)
                                            Text(category.rawValue)
                                        }
                                        .tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.ultraThinMaterial)
                                )
                            }
                            
                            CustomTextField(title: "Место", text: $location, placeholder: "Где потеряли/нашли?")
                            CustomTextField(title: "Контакты", text: $contactInfo, placeholder: "Телефон или email")
                            CustomTextField(title: "Награда (опционально)", text: $reward, placeholder: "Сумма или описание")
                            CustomTextField(title: "Теги", text: $tags, placeholder: "Ключевые слова через запятую")
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Новое объявление")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Опубликовать") {
                        // Здесь будет логика сохранения
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(minHeight: 100)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
    }
}

// MARK: - Item Detail View
struct ItemDetailView: View {
    let item: LostFoundItem
    @Environment(\.dismiss) private var dismiss
    @State private var isLiked = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: item.type.icon)
                                    .foregroundColor(.white)
                                Text(item.type.rawValue)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(item.type.color)
                            )
                            
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button(action: { isLiked.toggle() }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .red : .secondary)
                        }
                    }
                    
                    // Описание
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Детали
                    VStack(spacing: 12) {
                        DetailRow(icon: "location.fill", title: "Место", value: item.location)
                        DetailRow(icon: "calendar", title: "Дата", value: item.date.formatted(date: .abbreviated, time: .shortened))
                        DetailRow(icon: "tag.fill", title: "Категория", value: item.category.rawValue)
                        
                        if let reward = item.reward {
                            DetailRow(icon: "gift.fill", title: "Награда", value: reward)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Теги
                    if !item.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Теги")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                                ForEach(item.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.blue.opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                    
                    // Контакты
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Контакты")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                Text(item.contactInfo)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(20)
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

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    LostFoundView()
} 