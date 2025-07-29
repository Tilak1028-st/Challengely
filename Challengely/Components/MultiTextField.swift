//
//  MultiTextField.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import Foundation
import SwiftUI

struct MultiTextField: UIViewRepresentable {
    @Binding var text: String
    @EnvironmentObject var obj: Observed
    
    func makeCoordinator() -> Coordinator {
        return MultiTextField.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiTextField>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 17)
        view.text = "Type Something"
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
            uiView.textColor = UIColor.black
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultiTextField
        
        init(parent1: MultiTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "Type Something" {
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Only update parent text if it's not the placeholder
            if textView.text != "Type Something" {
                parent.text = textView.text
            } else {
                parent.text = ""
            }
            
            self.parent.obj.size = textView.contentSize.height
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Type Something"
                textView.textColor = UIColor.systemGray
            }
        }
    }
}
