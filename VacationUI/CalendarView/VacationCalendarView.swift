//
//  CalendarView.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 4/20/23.
//

import SwiftUI
import Foundation

struct VacationCalendarView: View {
    
    private enum Constant {
        static let secondInDay: TimeInterval = 24 * 3600
    }
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date.now + Constant.secondInDay * 3
    
    var body: some View {
        VStack {
            picker(title: "Начало отпуска", bindingDate: $startDate)
            picker(title: "Конец отпуска", bindingDate: $endDate)
            Spacer()
            CalendarSwiftUI(
                range: .init(
                    dateStart: startDate,
                    dateFinished: endDate,
                    color: .red
                )
            )
            .fixedSize()
        }
    }
    
    private func picker(
        title: String,
        bindingDate: Binding<Date>
    ) -> some View {
        DatePicker(
            title,
            selection: bindingDate,
            displayedComponents: .date
        )
        .padding(12)
    }
    
}

struct VacationCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        VacationCalendarView()
    }
}
