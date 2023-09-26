//
//  CustomSegmentedPicker.swift
//  Focus
//
//  Created by Musab Abdullah on 9/26/23.
//

import SwiftUI

/// This SegmentedPicker will take some Equatable array(Int, String, etc.)
public struct CustomSegmentedPicker<T: Equatable, Content: View>: View {
    // Tells SwiftUI which views can be animated together
    @Namespace private var selectionAnimation
    /// The currently selected item, if there is one
    @Binding var selectedItem: T
    /// The list of options available in this picker
    private let items: [T]
    /// The View that takes in one of the elements from the items array to display an item
    private let content: (T) -> Content

    private let onClick: (T) -> Void
    
    let cornerRadius = CGFloat(10.0)

    /// Create a new Segmented Picker
    /// - Parameters:
    ///     - selectedItem: The currently selected item, optional
    ///     - items: The list of items to display as options, can be any Equatable type such as String, Int, etc.
    ///     - content: The View to display for elements of the items array
    public init(_ items: [T],
            selectedItem: Binding<T>,
                onClick: @escaping (T) -> Void,
            @ViewBuilder content: @escaping (T) -> Content) {
        self._selectedItem = selectedItem
        self.items = items
        self.content = content
        self.onClick = onClick
    }
    
    // @ViewBuilder is a great way to conditionally show Views
    //   but makes the highlight overlay into "different" Views to the View Layout System
    @ViewBuilder func overlay(for item: T) -> some View {
        RoundedRectangle(cornerRadius: self.cornerRadius)
            .fill(Color.beige.opacity(item == selectedItem ? 1.0 : 0.0))
            .matchedGeometryEffect(id: "selectedSegmentHighlight", in: self.selectionAnimation, isSource: item == selectedItem)
    }

    public var body: some View {
        /// Horizontal is optional, could be vertical
        HStack {
            ForEach(self.items.indices, id: \.self) { index in
                // For each selectable option in the items array
                Button(action: {
                    onClick(self.items[index])
                    withAnimation(.linear) {
                        self.selectedItem = self.items[index]
                    }
                },
                       label: { self.content(self.items[index]) })
                .buttonStyle(.borderless)
                .contentShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                    .background(self.overlay(for: self.items[index]))
            }
        }
    }
}

struct CustomSegmentedPickerWrapper: View {

    @State var selected = TimerType.pomodoro

    var body: some View {
        CustomSegmentedPicker(TimerType.allCases, selectedItem: $selected, onClick: { type in
            print("clicked \(type)")
        }) { timerType in
            Text(timerType.rawValue)
                .foregroundColor(selected == timerType ? .darkBG : .beige)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
        }
        .frame(width: .infinity, height: 100)
    }
}

struct CustomSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPickerWrapper()
    }
}
