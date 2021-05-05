//
//  ContentView.swift
//  ChatBarAnimation
//
//  Created by Nerimene on 3/5/2021.
//

import SwiftUI

struct ContentView: View {
    // MARK:- variables
    @State var addAttachment: Bool = false
    @State var rotateBar: Bool = false
    @Binding var message: String
    var chatBarHeight: CGFloat = 86
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplay = false
    @State private var selectedImage: UIImage?
    @State var showAlert = false
    
    @ObservedObject var contacts = FetchedContacts()
    @State private var pick = false
    @State private var searchText: String = ""
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Color(red: 41/255, green: 121/255, blue: 255/255, opacity: 1.0)
                HStack {
                    AttachmentButton(needsRotation: $rotateBar, iconName: "plus", iconSize: 24, action: {
                        self.rotateBar.toggle()
                        self.addAttachment.toggle()
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (Timer) in
                            self.addAttachment.toggle()
                        }
                    })
                    Spacer()
                    ZStack {
                        ZStack {
                            HStack(alignment: .center, spacing: 20) {
                                AttachmentButton(needsRotation: .constant(false), iconName: "camera", action: {
                                    self.sourceType = .camera
                                    if UIImagePickerController.isSourceTypeAvailable(self.sourceType) {
                                        self.isImagePickerDisplay.toggle()
                                    } else {
                                        self.showAlert = true
                                    }
                                }).sheet(isPresented: self.$isImagePickerDisplay) {
                                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                                }
                                AttachmentButton(needsRotation: .constant(false), iconName: "video.fill", action: {
                                    self.sourceType = .photoLibrary
                                    self.isImagePickerDisplay.toggle()
                                }).sheet(isPresented: self.$isImagePickerDisplay) {
                                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                                }
                                AttachmentButton(needsRotation: .constant(false), iconName: "rectangle.stack.person.crop", action: {
                                    self.pick.toggle()
                                }).sheet(isPresented: self.$pick) {
                                    NavigationView {
                                        VStack {
                                            SearchBar(text: $searchText)
                                            List {
                                                ForEach(contacts.contacts.filter {
                                                    searchText.isEmpty ? true : ($0.firstName + " " + $0.lastName).lowercased().contains(searchText.lowercased())
                                                }) { contact in
                                                    VStack{
                                                        NavigationLink(destination: DetailedContactView(contact: contact)){
                                                            HStack{
                                                                Text(contact.firstName)
                                                                Text(contact.lastName)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding()
                                            .navigationTitle("Contacts")
                                            .navigationBarItems(trailing: Button("Fetch Contacts") {
                                                DispatchQueue.main.async {
                                                    contacts.fetchContacts()
                                                }
                                            })
                                        }
                                    }
                                }
                            }.alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Error 😔"),
                                    message: Text("Your actual device can not open the camera, please try to use a real device 😊")
                                )
                            }
                            .rotationEffect(!self.rotateBar ? .degrees(90) : .degrees(0), anchor: .zero)
                            .offset(y: !self.rotateBar ? 72 : 0)
                            .animation(Animation.spring())
                        }
                        ZStack {
                            TextField("Message", text: self.$message)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .disableAutocorrection(true)
                                .foregroundColor(Color.white)
                                .accentColor(Color.white)
                                .frame(height: 50)
                                .padding(.leading, 36)
                                .background(
                                    Color(red: 144/255, green: 202/255, blue: 249/255, opacity: 0.5)
                                        .cornerRadius(24)
                                        .padding(.leading)
                                )
                        }
                        .rotationEffect(self.rotateBar ? .degrees(-120) : .degrees(0), anchor: .zero)
                        .animation(Animation.spring())
                    }
                } .padding()
                .padding([.leading, .trailing], 8)
            }
            .frame(height: self.chatBarHeight)
            .cornerRadius(self.chatBarHeight / 2)
            .padding()
            .padding([.leading, .trailing], 24)
            .shadow(radius: 10)
            .rotationEffect(self.getBarRotationDegree(), anchor: .leading)
            .animation(
                Animation.interpolatingSpring(mass: 2, stiffness: 14, damping: 10, initialVelocity: 5)
                    .delay(0.1)
            )
        }
    }
    
    func getBarRotationDegree() -> Angle {
        if (self.rotateBar && self.addAttachment) {
            return .degrees(-3)
        } else if (self.addAttachment) {
            return .degrees(3)
        } else {
            return .degrees(0)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(message: .constant(""))
    }
}
