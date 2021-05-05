//
//  AttachmentButton.swift
//  ChatBarAnimation
//
//  Created by Nerimene on 3/5/2021.
//

import SwiftUI

struct AttachmentButton: View {
    @Binding var needsRotation: Bool
    @State var buttonPressAnimation: Bool = false
    var iconName: String
    var iconSize: CGFloat = 20
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: self.iconName)
                .font(.system(size: iconSize, weight: .medium, design: .rounded))
                .foregroundColor(Color.white)
                .padding()
                .frame(width: 52, height: 52)
                .background(Color(red: 144/255, green: 202/255, blue: 249/255, opacity: 0.5))
                .cornerRadius(32)
                .rotationEffect(self.needsRotation ? .degrees(137) : .degrees(0))
                .animation(Animation.easeIn(duration: 0.25).speed(1.5))
                .overlay(
                    Circle()
                        .opacity(self.buttonPressAnimation ? 0.1: 0)
                        .scaleEffect(self.buttonPressAnimation ? 0.95 : 0.5)
                        .animation(self.buttonPressAnimation ? .easeIn(duration: 0.25) : .easeIn(duration: 0))
                )
        }.onTapGesture {
            self.buttonPressAnimation.toggle()
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (Timer) in
                self.buttonPressAnimation.toggle()
            }
        }
    }
}
struct AttachmentButton_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentButton(needsRotation: .constant(true), iconName: "plus", action: {})
    }
}
