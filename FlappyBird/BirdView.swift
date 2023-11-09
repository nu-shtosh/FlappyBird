//
//  BirdView.swift
//  FlappyBird
//
//  Created by Илья Дубенский on 06.11.2023.
//

import SwiftUI

struct BirdView: View {
    let birdSize: CGFloat

    var body: some View {
        Image(.bird)
            .resizable()
            .scaledToFit()
            .frame(width: birdSize, height: birdSize)
            .border(.red, width: 2)
    }
}

#Preview {
    BirdView(birdSize: 80)
}
