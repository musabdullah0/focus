//
//  CustomSegmentedPicker.swift
//  Focus
//
//  Created by Musab Abdullah on 9/26/23.
//

import SwiftUI

public struct CustomSegmentedPicker: View {
    @Namespace private var selectionAnimation
    @Binding var selectedItem: TimerType

    private let onClick: (TimerType) -> Void
    
    let cornerRadius = CGFloat(10.0)

    init(selectedItem: Binding<TimerType>,
                onClick: @escaping (TimerType) -> Void) {
        self._selectedItem = selectedItem
        self.onClick = onClick
    }
    
    @ViewBuilder func overlay(for item: TimerType) -> some View {
        RoundedRectangle(cornerRadius: self.cornerRadius)
            .fill(Color.beige.opacity(item == selectedItem ? 1.0 : 0.0))
            .matchedGeometryEffect(id: "selectedSegmentHighlight", in: self.selectionAnimation, isSource: item == selectedItem)
    }

    public var body: some View {
        HStack {
            ForEach(TimerType.allCases, id: \.self) { type in
                Button(action: {
                    withAnimation(.linear(duration: 0.25)) {
                        self.selectedItem = type
                    }

                    onClick(type)
                }, label: {
                    Text(type.rawValue)
                        .foregroundColor(self.selectedItem == type ? .darkBG : .beige)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                })
                .buttonStyle(.borderless)
                .contentShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                    .background(self.overlay(for: type))
            }
        }
    }
}

struct CustomSegmentedPickerWrapper: View {

    @State var selected = TimerType.pomodoro

    var body: some View {
        CustomSegmentedPicker(selectedItem: $selected) { type in
            print("clicked \(type)")
        }
        .frame(width: .infinity, height: 100)
    }
}

struct CustomSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPickerWrapper()
    }
}
