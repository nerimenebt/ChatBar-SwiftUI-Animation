//
//  DetailedContactView.swift
//  ChatBarAnimation
//
//  Created by Nerimene on 3/5/2021.
//

import SwiftUI

struct DetailedContactView: View {
    
    var contact: Contact
    
    var body: some View {
        VStack{
            HStack{
                Text(contact.firstName)
                Text(contact.lastName)
            }
            ForEach(contact.phoneNumbers, id:\.self) { number in
                Text(number)
            }
            ForEach(contact.emailAddresses, id:\.self) { email in
                Text(email)
            }
        }
    }
}
