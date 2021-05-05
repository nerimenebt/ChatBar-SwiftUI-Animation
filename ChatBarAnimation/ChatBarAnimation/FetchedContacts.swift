//
//  FetchedContacts.swift
//  ChatBarAnimation
//
//  Created by Nerimene on 3/5/2021.
//

import SwiftUI
import Contacts

struct Contact: Identifiable, Hashable {
    var id = UUID()
    var firstName: String //= "No firstName"
    var lastName: String //= "No lastName"
    var phoneNumbers: [String] //= []
    var emailAddresses: [String]// = []
}

class FetchedContacts: ObservableObject, Identifiable {
    
    @Published var contacts = [Contact]()
    
    func fetchContacts() {
        contacts.removeAll()
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName, phoneNumbers: contact.phoneNumbers.map { $0.value.stringValue }, emailAddresses: contact.emailAddresses.map { $0.value as String }
                        ))
                        self.contacts.sort(by: { $0.firstName < $1.firstName })
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
}

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText != "" {
                searchBar.showsCancelButton = true
            }
            text = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            text = ""
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
