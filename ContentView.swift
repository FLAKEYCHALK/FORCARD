import SwiftUI

struct Flashcard: Identifiable {
    let id = UUID()
    var question: String
    var answer: String
}

struct NeumorphicButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
        }
    }
}

struct FlashcardView: View {
    @State private var isFlipped = false
    var flashcard: Flashcard
    
    var body: some View {
        VStack {
            Spacer()
            
            if isFlipped {
                Text(flashcard.answer)
                    .font(.system(size: 25))
                    .padding()
            } else {
                Text(flashcard.question)
                    .font(.system(size: 25))
                    .padding()
            }
            
            Spacer()
        }
        .frame(width: 350, height: 200)
        .background(Color(.systemGray5).opacity(isFlipped ? 0.6 : 1.0))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isFlipped.toggle()
            }
        }
    }
}


struct NewFlashcardForm: View {
    @Binding var flashcards: [Flashcard]
    @Binding var showingForm: Bool
    @State private var newQuestion = ""
    @State private var newAnswer = ""
    
    private func addFlashcard() {
        flashcards.append(Flashcard(question: newQuestion, answer: newAnswer))
        newQuestion = ""
        newAnswer = ""
        showingForm = false
    }
    
    var body: some View {
        VStack {
            TextField("Question", text: $newQuestion)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
                .padding()
            TextField("Answer", text: $newAnswer)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
                .padding()
            NeumorphicButton(title: "Add", action: addFlashcard)
                .padding()
        }
    }
}

struct ContentView: View {
    @State private var flashcards: [Flashcard] = []
    
    @State private var showingForm = false
    
    private func clearFlashCards() {
        flashcards = []
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    LazyVStack {
                        Spacer()
                        ForEach(flashcards) { flashcard in
                            FlashcardView(flashcard: flashcard)
                                .padding(.bottom)
                        }
                    }
                }
                HStack {
                    NeumorphicButton(title: "Clear", action: clearFlashCards)
                    NeumorphicButton(title: "New Flashcard", action: { showingForm = true })
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingForm) {
                    NewFlashcardForm(flashcards: $flashcards, showingForm: $showingForm)
                }
                .padding()
            }
        }
    }
}


