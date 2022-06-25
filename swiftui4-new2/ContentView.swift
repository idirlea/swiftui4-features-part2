//
//  ContentView.swift
//  swiftui4-new2
//
//  Created by Ionut Dirlea on 25.06.2022.
//

import SwiftUI

let text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc enim ipsum, consequat id odio et, finibus dictum sem. Duis sagittis mauris lectus, eu pulvinar tellus fringilla quis. Morbi tristique egestas lacus, sed scelerisque lacus lacinia et. Etiam feugiat diam sem, et malesuada lectus faucibus a.
"""

struct ContentView: View {
    @State var isConfirmationSheetOpen = false
    @State var selectedDates:Set<DateComponents> = []
    
    @State var selectedInterval = "none"
    
    @State var status:Double = 0
    
    @State var toggle1 = false
    @State var toggle2 = false
    @State var toggle3 = false
    
    var bounds:Range<Date> {
        let start = Calendar.current.date(from: DateComponents(timeZone: .current, year: 2022, month: 06, day: 25))!
        let end = Calendar.current.date(from: DateComponents(timeZone: .current, year: 2022, month: 21, day: 31))!
        
        return start..<end
        
                                          
    }
    
    func getDateInterval(date:Set<DateComponents>) -> String {
        let datesArr:[Date] = Array(date).map { d in
            Calendar.current.date(from: d)!
        }.sorted { d1, d2 in
            d1 < d2
        }
        
        if datesArr.count == 2 {
            return "\(datesArr[0].formatted(date: .abbreviated, time: .omitted)) - \(datesArr[1].formatted(date: .abbreviated, time: .omitted))"
        }
        
        return "none"
    }
    
    var body: some View {
        VStack {
            Image(systemName: "airplane.departure")
                .font(.system(size: 50))
                .background(in: RoundedRectangle(cornerRadius: 5).inset(by: -15))
                .backgroundStyle(.green.gradient.shadow(.inner(radius: 2)))
                .foregroundStyle(.white.shadow(.drop(radius: 3)))
            VStack(alignment: .center, spacing: 20) {
                Text("Confirm period")
                    .font(.title)
                Text(text)
                HStack(alignment: .center, spacing: 10) {
                    Text("Select dates:")
                    Spacer()
                    Button {
                        isConfirmationSheetOpen.toggle()
                    } label: {
                        Text(selectedInterval)
                    }
                }
                
                Image(systemName: "ellipsis", variableValue: status)
                    .font(.system(size: 50))
                
                Toggle("I agree to temrs 1", isOn: $toggle1)
                Toggle("I agree to temrs 2", isOn: $toggle2)
                Toggle("I agree to temrs 3", isOn: $toggle3)
                
                Toggle("I agree to all", isOn: [$toggle1, $toggle2, $toggle3])
                
            }
            .offset(y: 40)
            .padding(20)
        }.sheet(isPresented: $isConfirmationSheetOpen) {
            VStack(alignment: .leading, spacing: 10) {
                MultiDatePicker("Dates", selection: $selectedDates, in: bounds)
            }
            .padding(10)
            .presentationDetents([.medium])
        }.onChange(of: selectedDates) { newValue in
            if(newValue.capacity > 1) {
                // call a function to extract the dates from the Set
                selectedInterval = getDateInterval(date: newValue)
                isConfirmationSheetOpen.toggle()
            }
        }.onChange(of: [toggle1, toggle2, toggle3]) { newValue in
            status = 0
            newValue.forEach { val in
                if val {
                    status += 0.33
                }
            }
        }.persistentSystemOverlays(.hidden)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
