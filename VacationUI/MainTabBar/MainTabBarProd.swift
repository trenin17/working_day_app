//
//  MainTabBar.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 4/19/23.
//

import SwiftUI
import EFNetwork

struct MainTabBarProd: View {
    
    @EnvironmentObject var networkManagerService: EnvironmentService<EFNetworkManager>
    @EnvironmentObject var credentialsStore: CredentialsStore
    
    init() {
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some View {
        TabView {
            calendar
            employeeListItem
            if let id = credentialsStore.credentials?.id {
                myProfileItem(with: id)
            }
        }
    }
    
    
    func myProfileItem(with id: String) -> some View {
        ProfileContainer(
            manager: networkManagerService.serivce,
            credentialsStore: credentialsStore
        )
        .myProfile()
        .tabItem {
            Label("Профиль", systemImage: "person.circle.fill")
        }
    }
    
    var employeeListItem: some View {
        EmployeeListView(
            store: EmployeeListStore(networkManager: networkManagerService.serivce),
            profileContainer: ProfileContainer(
                manager: networkManagerService.serivce,
                credentialsStore: credentialsStore
            )
        )
        .tabItem {
            Label("Сотрудники", systemImage: "person.3.fill")
        }
    }
    
    var calendar: some View {
        ProfileCalendar_Prod(
            store: ProfileCalendarStore(networkManager: networkManagerService.serivce)
        )
        .tabItem {
            Label(
                "Календарь",
                systemImage: "calendar"
            )
        }
    }
    
}

struct MainTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarProd()
    }
}

