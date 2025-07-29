import SwiftUI

struct ChatInputView: View {
    @EnvironmentObject var obj: Observed
    @Binding var messageText: String
    var onSend: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            ZStack(alignment: .topLeading) {
                
                MultiTextField(text: $messageText)
                    .frame(height: self.obj.size < 120 ? self.obj.size : 120)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color("Card"))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                isFocused ? Color("PrimaryColor").opacity(0.3) : Color("Divider"),
                                lineWidth: isFocused ? 1.5 : 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }

            Button(action: {
                onSend()
                messageText = ""
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        messageText.isEmpty 
                        ? Color("Subtext").opacity(0.3) 
                        : Color("PrimaryColor")
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            }
            .disabled(messageText.isEmpty)
            .scaleEffect(messageText.isEmpty ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: messageText.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Color("Background")
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -2)
        )
    }
}


class Observed: ObservableObject {
    @Published var size: CGFloat = 0
}
