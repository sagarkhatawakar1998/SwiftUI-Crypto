//
//  XmarkButton.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 12/04/23.
//

import SwiftUI

struct XmarkButton: View {
    
    @Environment(\.presentationMode) var presentaionMode
    
    var body: some View {
        Button(action: {
           presentaionMode.wrappedValue.dismiss()
       }, label: {
           Image(systemName: "xmark")
       })
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton()
    }
}
