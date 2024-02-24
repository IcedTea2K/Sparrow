//
//  RoundTableView.swift
//
//
//  Created by Minh Au on 2024-02-22.
//

import Foundation
import SwiftUI

struct RoundTableView: View {
    var body: some View {
        VStack {
            Table()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#e9edc9"))
    }
}

struct Table: View {
    @State
    private var people: [String] = []
    
    private let colors: [String] = [
        "#D1C6DF", "#B2A8D5", "#FADBC7", "#475164", "#FFA7A7",
        "#F8E5B3", "#9AD4C5", "#EEA9A2", "#A5ADBB", "#EBEFF2",
        "#F4C29E", "#BFB4C4", "#FFB08E", "#6AB1E3", "#F9CF8D",
        "#A8DEC9", "#E7B3A0", "#7E5C8F", "#FAD685", "#B3E1C2",
        "#D9CCEA", "#F7C67A", "#AEC8EF", "#F9E2D2", "#B9BBC2",
        "#D7C9E5", "#FFAB90", "#B3E1C2", "#E5D6ED", "#FAD9A9"
    ]
    var body: some View {
        let diameter: CGFloat = 250
        let radius: CGFloat = diameter / 2
        let space = 2 * CGFloat.pi / CGFloat(people.count)
        let randStart = CGFloat.random(in: 0 ... 2 * CGFloat.pi)
        
        ZStack {
            Circle()
                .fill(Color(hex: "#ccd5ae"))
                .frame(width: diameter, height: diameter)
                .onTapGesture {
                    people.append("Rey")
                }
            ForEach(Array(people.enumerated()), id: \.offset) { i, person in
                Person(name: person, size: 30, color: colors.randomElement())
                    .offset(x: (radius + 30 / 2) * cos(randStart + space * CGFloat(i)),
                            y: (radius + 30 / 2) * sin(randStart + space * CGFloat(i)))
            }
        }
    }
    
}

struct Person: View {
    var name: String
    var size: CGFloat // circle radius for now
    @State
    var color: String? // hex string
    var body: some View {
        Circle()
            .fill(Color(hex: color!))
            .frame(width: size, height: size)
    }
}
#Preview {
    RoundTableView()
}
