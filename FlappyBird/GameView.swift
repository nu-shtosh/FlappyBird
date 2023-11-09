//
//  GameView.swift
//  FlappyBird
//
//  Created by Илья Дубенский on 06.11.2023.
//

import SwiftUI

enum GameState {
    case ready, active, stopped
}

struct GameView: View {
    @AppStorage(wrappedValue: 0, "highScore") private var highScore: Int


    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    @State private var birdPosition: CGPoint = CGPoint(x: 100, y: 300)

    @State private var lastUpdateTime = Date()

    @State private var pipeOffset: CGFloat = 0
    @State private var topPipeHeight: CGFloat = CGFloat.random(in: 100...500)

    @State private var passedPipe = false
    @State private var score: Int = 0
    @State private var gameState: GameState = .ready

    private let birdSize: CGFloat = 50
    private let birdRadius: CGFloat = 30

    private let pipeWidth: CGFloat = 130
    private let pipeSpacing: CGFloat = 130
    private let pipeSpeed: CGFloat = 250

    private let jumpVelocity: CGFloat = -400
    private let gravity: CGFloat = 1000
    private let groundHeight: CGFloat = 50


    private let timer = Timer.publish(every: 0.01,
                                      on: .main,
                                      in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image(.background)
                        .resizable()
                        .ignoresSafeArea()
                        .padding(EdgeInsets(top: 0,
                                            leading: 0,
                                            bottom: -50,
                                            trailing: -50))

                    BirdView(birdSize: birdSize)
                        .position(birdPosition)

                    PipeView(pipeWidth: pipeWidth,
                             topPipeHeight: topPipeHeight,
                             pipeSpacing: pipeSpacing)
                    .offset(x: geometry.size.width + pipeOffset)

                    if gameState == .ready {
                        Button {
                            playButtonAction()
                        } label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(.white)
                        }
                    }

                    if gameState == .stopped {
                        ResultView(score: score,
                                   highScore: highScore) {
                            resetGame()
                        }
                    }
                }
                .onTapGesture {
                    birdVelocity = CGVector(dx: 0, dy: jumpVelocity)
                }
                .onReceive(timer) { currentTime in
                    guard gameState == .active else { return }
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)

                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBoundaries(geometry: geometry)
                    updatePipePosition(deltaTime: deltaTime)
                    resetPipePositionIfNeeded(geometry: geometry)

                    if checkCollisions(geometry: geometry) {
                        gameState = .stopped
                    }

                    updateScores(geometry: geometry)
                    lastUpdateTime = currentTime
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text(score.description)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }

    private func updateScores(geometry: GeometryProxy) {
        if pipeOffset + pipeWidth + geometry.size.width < birdPosition.x && !passedPipe {
            score += 1

            if score > highScore {
                highScore = score
            }
            passedPipe = true
        } else if pipeOffset + geometry.size.width > birdPosition.x {
            passedPipe = false
        }
    }

    private func playButtonAction() {
        gameState = .active
        lastUpdateTime = .now
    }

    private func resetGame() {
        birdPosition = CGPoint(x: 100, y: 300)
        birdVelocity = CGVector(dx: 0, dy: 0)
        pipeOffset = 0
        topPipeHeight =  CGFloat.random(in: 100...500)
        score = 0
        gameState = .ready
    }

    private func applyGravity(deltaTime: TimeInterval) {
        birdVelocity.dy += CGFloat(gravity * deltaTime)
    }

    private func updateBirdPosition(deltaTime: TimeInterval) {
        birdPosition.y += birdVelocity.dy * CGFloat(deltaTime)
    }

    private func checkCollisions(geometry: GeometryProxy) -> Bool {
        let birdFrame = CGRect(x: birdPosition.x - birdRadius / 2,
                               y: birdPosition.y - birdRadius / 2,
                               width: birdRadius,
                               height: birdRadius)

        let topPipeFrame = CGRect(x: geometry.size.width + pipeOffset,
                                  y: 0,
                                  width: pipeWidth,
                                  height: topPipeHeight)

        let bottomPipeFrame = CGRect(x: geometry.size.width + pipeOffset,
                                     y: topPipeHeight + pipeSpacing,
                                     width: pipeWidth,
                                     height: topPipeHeight)

        return birdFrame.intersects(topPipeFrame) || birdFrame.intersects(bottomPipeFrame)
    }

    private func checkBoundaries(geometry: GeometryProxy) {
        if birdPosition.y <= 0 {
            birdPosition.y = 0
            gameState = .stopped
        }

        if birdPosition.y > geometry.size.height - groundHeight {
            birdPosition.y = geometry.size.height - groundHeight
            birdVelocity.dy = 0
            gameState = .stopped
        }
    }

    private func updatePipePosition(deltaTime: TimeInterval) {
        pipeOffset -= CGFloat(pipeSpeed * deltaTime)
    }

    private func resetPipePositionIfNeeded(geometry: GeometryProxy) {
        if pipeOffset <= -geometry.size.width - pipeWidth {
            pipeOffset = 0
            topPipeHeight = CGFloat.random(in: 100...500)
        }
    }
}

#Preview {
    GameView()
}
