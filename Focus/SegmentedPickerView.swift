//
//  SegmentedPickerView.swift
//  Focus
//
//  Created by Musab Abdullah on 9/25/23.
//

import SwiftUI


struct SegmentedPickerView: View {
    
    let segments: [TimerType]
    @Binding var selected: TimerType
    
    var onClick: (TimerType) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimerType.allCases, id: \.self) { option in
                Button {
                    self.onClick(option)
                } label: {
                    VStack {
                        Text(option.rawValue)
                            .font(.footnote)
                            .padding(.horizontal, 10)
                            .foregroundColor(selected == option ? Color.darkBG : Color.beige)
                            .tag(option)
                            
                    }
                }
                .background(self.selected == option ? Color.beige : Color.darkBG)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

struct ContentView: View {

    @State var selected = TimerType.pomodoro

    var body: some View {
        VStack {
            SegmentedPickerView(segments: TimerType.allCases, selected: $selected) { order in
                print("clicked \(order)")
            }
        }
    }
}

struct SegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
