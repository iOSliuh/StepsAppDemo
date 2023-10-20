//
//  RingAnimation.swift
//  StepsAppDemo
//
//  Created by liuhao on 17/10/2023.
//

import SwiftUI
enum CircleType: String {
    case Step = "步"
    case Calory = "千卡"
    case Distance = "公里"
    case Duration = "分钟"
}

struct RingAnimation: View {
    @ObservedObject var model: HealthKitViewModel
    @State private var drawingStroke = false
    
    let radius: CGFloat
    let lineWidth: CGFloat
    let strokeWidth: CGFloat
    let animation = Animation.easeOut(duration: 0.5).delay(0.1)

    let type: CircleType
 
    var body: some View {
        ZStack {
            ring(for: Color.mainColor)
                .frame(width: radius)
        }
        .animation(animation, value: drawingStroke)
        .onAppear { drawingStroke = true  }
    }
 
    func ring(for color: Color) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: lineWidth))
            .foregroundStyle(Color.stepGray)
            .overlay {
                Circle()
                    .trim(from: 0, to: drawingStroke ? getRatio() : 0)  // 1
                    .stroke(color.gradient,
                            style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            }
            
            .rotationEffect(.degrees(-90))
    }
    
    func getRatio() -> Double {
        switch type {
        case .Step:
            return Double(model.currentSteps) / Double(Constants.targetStep)
        case .Calory:
            return model.currentCalories / Double(Constants.targetCalory)
        case .Distance:
            return model.currentDistance / Double(Constants.targetMile)
        case .Duration:
            return Double(model.currentDuration / Constants.targetDuration) 
        }
    }
}



