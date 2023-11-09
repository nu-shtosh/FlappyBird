//
//  PipeView.swift
//  FlappyBird
//
//  Created by Илья Дубенский on 06.11.2023.
//

import SwiftUI

struct PipeView: View {

    let pipeWidth: CGFloat
    let topPipeHeight: CGFloat
    let pipeSpacing: CGFloat

    var body: some View {
        GeometryReader { geometry in
            VStack {
                let availableHeight = geometry.size.height - pipeSpacing
                let bottomHeight = availableHeight - topPipeHeight

                Image(.pipe)
                    .resizable()
                    .frame(width: pipeWidth, height: topPipeHeight)
                    .rotationEffect(.degrees(180))
                    .border(.red, width: 2)

                Spacer()
                    .frame(height: pipeSpacing)

                Image(.pipe)
                    .resizable()
                    .frame(width: pipeWidth, height: bottomHeight)
                    .border(.red, width: 2)
            }
        }
    }
}

#Preview {
    PipeView(pipeWidth: 100, topPipeHeight: 300, pipeSpacing: 100)
}
