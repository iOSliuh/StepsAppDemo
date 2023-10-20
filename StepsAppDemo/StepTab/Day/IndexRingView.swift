//
//  IndexRingView.swift
//  StepsAppDemo
//
//  Created by liuhao on 17/10/2023.
//

import SwiftUI

enum Index: String {
    case Calory = "千卡"
    case Distance = "公里"
    case Duration = "分钟"
}

struct IndexRingView: View {
    @ObservedObject var viewModel: HealthKitViewModel

    var num: String
    let type: CircleType
    
    var body: some View {
        VStack {
            ZStack {
                RingAnimation(model: viewModel, radius: Constants.radiusIndexRing, lineWidth: Constants.lineWidthIndexRing, strokeWidth: Constants.strokeWidthIndexRing, type: type)
                Image(systemName: getImageName())
            }
            
            Text("\(num) \(type.rawValue)")
                .foregroundColor(.black)
                .font(Font.system(size: 15, weight: .bold))
        }
    }
    
    func getImageName() -> String {
        switch type {
        case .Step:
            return ""
        case .Calory:
            return "drop"
        case .Distance:
            return "arrow.right"
        case .Duration:
            return "clock"
        }
    }
}

#Preview {
    IndexRingView(viewModel: HealthKitViewModel(), num: "2.1", type: .Distance)
}

