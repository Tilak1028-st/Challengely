//
//  MultiTextField.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import Foundation
import SwiftUI

/// Custom multi-line text input component that dynamically adjusts its height
/// Wraps UITextView to provide SwiftUI compatibility with dynamic sizing
struct MultiTextField: UIViewRepresentable {
    @Binding var text: String
    @EnvironmentObject var obj: Observed
    
    func makeCoordinator() -> Coordinator {
        return MultiTextField.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiTextField>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 17)
        view.text = Constants.Placeholder.typeSomething
        view.textColor = UIColor.systemGray
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        
        // Set initial size after view is configured
        DispatchQueue.main.async {
            self.obj.size = view.contentSize.height
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiTextField>) {
        // Only update if the text has actually changed and is not empty
        if uiView.text != text && !text.isEmpty {
            uiView.text = text
            uiView.textColor = UIColor.label
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultiTextField
        
        init(parent1: MultiTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Clear placeholder when user starts typing
            if textView.text == Constants.Placeholder.typeSomething {
                textView.text = ""
                textView.textColor = UIColor.label
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Update parent text and notify size change
            if textView.text != Constants.Placeholder.typeSomething {
                parent.text = textView.text
            } else {
                parent.text = ""
            }
            
            self.parent.obj.size = textView.contentSize.height
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            // Show placeholder if text is empty
            if textView.text.isEmpty {
                textView.text = Constants.Placeholder.typeSomething
                textView.textColor = UIColor.systemGray
            }
        }
    }
}
