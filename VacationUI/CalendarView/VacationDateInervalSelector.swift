import SwiftUI

extension Date {
    func addingDays(_ numberOfDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numberOfDays, to: noon)!
    }
    private var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

struct VacationDateInervalSelector: View {
    
    private enum Constant {
        static let vacationReasonPlaceholder = "Текст заявления на отпуск"
    }
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var startDate: Date// = Date()
    @Binding var endDate: Date// = Date().addingDays(1)
    @State var vacationReason = ""
    @State var isPresentingAlert = false
    @ObservedObject var store: VacationRequestStore
    
    var body: some View {
        VStack {
            navigationView
            Spacer()
            dismissIfNeeded()
            viewForState()
            Spacer()
        }
    }
    
    private var navigationView: some View {
        TopNavigationView()
        .leadView {
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            )
        }
    }
    
    private func dismissIfNeeded() -> some View {
        switch store.viewState {
        case.dismissFailure, .dismissSuccess:
            presentationMode.wrappedValue.dismiss()
        case .editing, .sendingRequest:
            break
        }
        return EmptyView()
    }
    
    @ViewBuilder
    private func viewForState() -> some View {
        switch store.viewState {
        case .editing:
            VStack(spacing: 20) {
                datePickerView(text: "Начало отпуска", date: $startDate)
                datePickerView(text: "Конец отпуска", date: $endDate)
                Spacer().frame(height: 5)
                vacationReasonTextView
                sendVacationRequestButton
            }.onAppear {
                self.startDate = Date()
                self.endDate = Date().addingDays(1)
            }
            .padding(30)
        case .sendingRequest:
            VStack {
                Spacer()
                ProgressView()
                Spacer()
                Spacer()
            }
        case .dismissSuccess:
            EmptyView()
        case .dismissFailure:
            EmptyView()
        }
    }
    
    private func datePickerView(
        text: String,
        date: Binding<Date>
    ) -> some View {
        DatePicker(
            text,
            selection: date,
            in: Date()...Date.distantFuture,
            displayedComponents: [.date]
        )
        
    }
    
    private var vacationReasonTextView: some View {
        TextField(
            Constant.vacationReasonPlaceholder,
            text: $vacationReason,
            axis: .vertical
        )
        .autocorrectionDisabled(true)
        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 6))
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(8)
        .lineLimit(5...10)
    }
    
    private var sendVacationRequestButton: some View {
        Button(
            action: {
                store.sendNetworkReqeust(
                    text: vacationReason,
                    startDate: startDate,
                    endDate: endDate
                )
            },
            label: {
                ZStack {
                    ColorPalette.activeControl
                    Text("Отправить заявление")
                        .foregroundColor(.white)
                }
                .aspectRatio(7, contentMode: .fit)
                .cornerRadius(10)
            }
        )
    }
}

struct VacationDateInervalSelector_Previews: PreviewProvider {
    
    @State static var startDate = Date()
    @State static var endDate = Date().addingDays(1)
    
    static var previews: some View {
        VacationDateInervalSelector(
            startDate: $startDate,
            endDate: $endDate,
            store: VacationRequestStore(
                networkManager: .default,
                calendarStore: ProfileCalendarStore(networkManager: .default)
            )
        )
    }
}

fileprivate extension View {
    func todoVacationAlert(_ toggler: Binding<Bool>) -> some View {
        self.alert(
            "TODO: send vacationAlert",
            isPresented: toggler,
            actions: {
                Button("OK") { toggler.wrappedValue.toggle() }
            }
        )
    }
}
