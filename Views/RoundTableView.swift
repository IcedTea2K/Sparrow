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
                Person(name: person, size: 50)
                    .offset(x: (radius + 25) * cos(randStart + space * CGFloat(i)),
                            y: (radius + 25) * sin(randStart + space * CGFloat(i)))
            }
        }
    }
    
}

struct Person: View {
    var name: String
    var size: CGFloat // circle radius for now
    var body: some View {
        Circle()
            .fill(Color(hex: "#d4a373"))
            .frame(width: size, height: size)
    }
}
#Preview {
    RoundTableView()
}
