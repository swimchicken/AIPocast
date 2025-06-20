//
//  WaveView.swift
//  AIPodcast01
//
//  Created by swimchichen on 2025/6/20.
//

import SwiftUI

private struct Wave: Identifiable {
    let id = UUID()
    let creationDate = Date()
}

struct WaveView: View {
    // 接收來自父視圖的尺寸
    let size: CGFloat

    @State private var waves: [Wave] = []
    
    private let waveCreationTimer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    private let waveColor = Color(red: 1.0, green: 0.6, blue: 0.2)
    private let animationDuration: Double = 3.0

    var body: some View {
        TimelineView(.animation) { context in
            ZStack {
                // 這個 ZStack 的 frame 與傳入的 size 相同，確保波紋在正確的尺寸內擴散
                ForEach(waves) { wave in
                    let timeSinceCreation = context.date.timeIntervalSince(wave.creationDate)
                    
                    if timeSinceCreation >= 0 && timeSinceCreation < animationDuration {
                        let progress = timeSinceCreation / animationDuration
                        
                        Circle()
                            .stroke(waveColor, lineWidth: 2)
                            // 擴散效果現在基於傳入的尺寸，讓動畫看起來更協調
                            .scaleEffect(progress * (size / 180))
                            .opacity(1.0 - progress)
                    }
                }
            }
            .frame(width: size, height: size) // 設定 ZStack 的大小
            .onReceive(waveCreationTimer) { _ in
                waves.append(Wave())
                waves.removeAll { wave in
                    context.date.timeIntervalSince(wave.creationDate) >= animationDuration
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        // 在預覽中提供一個模擬尺寸
        WaveView(size: 390)
            .offset(y: 390 / 2)
    }
}
