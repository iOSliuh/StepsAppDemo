//
//  CoreRingView.swift
//  StepsAppDemo
//
//  Created by liuhao on 17/10/2023.
//

import SwiftUI
struct CoreRingView: View {
    @ObservedObject var viewModel: HealthKitViewModel
    
    var body: some View {
        
        ZStack {
            RingAnimation(model: viewModel, radius: Constants.radiusCoreRing, lineWidth: Constants.lineWidthCoreRing, strokeWidth: Constants.strokeWidthCoreRing, type: .Step)
            VStack {
                Image(systemName: "figure")
                Text("\(viewModel.currentSteps)")
                    .font(Font.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                Text(Constants.textToday)
                    .font(Font.system(size: 18, weight: .bold))
                    .foregroundColor(.dateGray)
                Text("\(Constants.textTarget)\(6000)")
                    .font(Font.system(size: 10, weight: .bold))
                    .foregroundColor(.dateGray)
            }
        }
    }
}

#Preview {
    CoreRingView(viewModel: HealthKitViewModel())
}

