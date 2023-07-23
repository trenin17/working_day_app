//
//  VacationTextField.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 5/21/23.
//

import SwiftUI

struct VacationTextField: View {
    var placeholder = ""
    @Binding var text: String
    var axis: Axis = .horizontal
    var edgeInsets: EdgeInsets = EdgeInsets(top: 0, leading: 12, bottom: 6, trailing: 0)
    var backgroundColor = Color(uiColor: .systemGray5)
    
    var body: some View {
        TextField(
            placeholder,
            text: $text,
            axis: axis
        )
        .autocorrectionDisabled(true)
        .padding(edgeInsets)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(8)
    }
}

struct VacationTextField_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        VacationTextField(text: $text)
    }
}
