import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    let messageType: MessageType
    
    enum MessageType: String, Codable {
        case text
        case suggestion
        case system
    }
    
    init(content: String, isFromUser: Bool, messageType: MessageType = .text) {
        self.id = UUID()
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = Date()
        self.messageType = messageType
    }
    
    init(id: UUID, content: String, isFromUser: Bool, timestamp: Date, messageType: MessageType = .text) {
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.messageType = messageType
    }
}

struct ChatSuggestion: Identifiable {
    let id = UUID()
    let text: String
    let action: String
} 