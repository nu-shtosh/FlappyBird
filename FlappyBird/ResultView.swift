//
//  ResultView.swift
//  FlappyBird
//
//  Created by Илья Дубенский on 06.11.2023.
//

import SwiftUI

struct ResultView: View {

    let score: Int
    let highScore: Int
    let resetAction: () -> ()

    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .padding()

            Text("Score: \(score)")
                .font(.title)

            Text("High Score: \(highScore)")
                .font(.caption)

            Button {
                resetAction()
            } label: {
                Text("Reset".uppercased())
                    .padding()
                    .padding(.horizontal)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 10.0))
            }
            .padding()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20.0))
    }
}

#Preview {
    ZStack {
        Color.gray
        ResultView(score: 1, highScore: 2, resetAction: { })
    }
}
