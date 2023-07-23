//
//  ProfileButtonsList.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 7/23/23.
//

import SwiftUI
import EFNetwork

struct EitherEmployeeProfileButtonList: View {
    
    @ObservedObject var store: ProfileCalendarStore
//    let action: () -> Void
    @State var isPresentingCalendar: Bool = false
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: {
                    NotificationsView(
                        store: NotificationsStore(mock_notifications: [])
                    )
                    .navigationBarBackButtonHidden(true)
                },
                label: {
                    ProfileButtonView(title: "Запросы", action: nil)
                }
            )
            
            ProfileButtonView(title: "Посещаемость") {
                isPresentingCalendar.toggle()
            }.sheet(isPresented: $isPresentingCalendar) {
                VacationStoredCalendarView(store: store)
            }
        }
    }
    
}

struct VacationStoredCalendarView: View {
    
    @ObservedObject var store: ProfileCalendarStore
    
    var body: some View {
        storeStateView.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.fetchState()
            }
        }
    }
    
    @ViewBuilder
    var storeStateView: some View {
        switch store.state {
        case .initial:
            ProgressView()
        case .loading:
            ProgressView()
        case .loaded(let actions):
            FSCalnderApater(actions: actions)
        case .error:
            Text("Что-то пошло не так").foregroundColor(.red)
        }
    }
}

