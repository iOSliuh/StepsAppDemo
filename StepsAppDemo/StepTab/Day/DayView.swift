//
//  DayView.swift
//  StepsAppDemo
//
//  Created by liuhao on 17/10/2023.
//

import SwiftUI

struct DayView: View {
    @ObservedObject var viewModel: HealthKitViewModel
    @State private var showingBottomSheet = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            CoreRingView(viewModel: viewModel)
            Spacer().frame(height: 30)
            HStack {
                Spacer()
                IndexRingView(viewModel: viewModel, num: String(format: "%.1f", viewModel.currentCalories ), type: .Calory)
                Spacer()
                IndexRingView(viewModel: viewModel, num: String(format: "%.1f", viewModel.currentDistance / 1000 ), type: .Distance)
                Spacer()
                IndexRingView(viewModel: viewModel, num: String(format: "%.1f", viewModel.currentDuration), type: .Duration)
                Spacer()
            }
            Spacer().frame(height: 20)
            GradientStepLineChartView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingBottomSheet) {
            VStack() {
                Spacer()
                Image(systemName: "figure.walk")
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .font(Font.system(size: 80))
                    .cornerRadius(20)
                
                Spacer().frame(height: 30)
                Text(Constants.textSenserBeenOff)
                    .font(Font.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                Spacer().frame(height: 10)
                Text(Constants.textSenserSettingInfo)
                    .font(Font.system(size: 14, weight: .regular))
                    .foregroundColor(.stepGray)
                
                Spacer().frame(height: 140)
                Button {
                    goToSetting()
                } label: {
                    Text(Constants.textSetting)
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color.mainColor.cornerRadius(10))
                        .shadow(color: Color.mainColor.opacity(0.3), radius: 10, x: 0.0, y: 10.0)
                        .padding(.leading,20)
                        .padding(.trailing,20)
                }
                .cornerRadius(40)
                .presentationDetents([.height(550)])
                .interactiveDismissDisabled(true)
            }
        }
        .onAppear {
            viewModel.requestAuthorization { isSuccess in
               /* guard viewModel.authorizationStatus else {
                    showingBottomSheet = true
                    return
                }
                showingBottomSheet = false
               */
                if isSuccess == true {
                    viewModel.querySteps { statsCollection in
                        if let statsCollection = statsCollection {
                            viewModel.updateUIFromStats(statsCollection)
                        }
                    }
                    viewModel.queryCalories { statsCollection in
                        if let statsCollection = statsCollection {
                            viewModel.updateCalorieUIFromStats(statsCollection)
                        }
                    }
                    viewModel.queryDistance { statsCollection in
                        if let statsCollection = statsCollection {
                            viewModel.updateDistanceUIFromStats(statsCollection)
                        }
                    }
                    viewModel.queryExerciseTime { statsCollection in
                        if let statsCollection = statsCollection {
                            viewModel.updateExerciseTimeUIFromStats(statsCollection)
                        }
                    }
                }
            }
        }
    }
}

extension DayView {
    func goToSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                
            }
        }
    }
}


#Preview {
    DayView(viewModel: HealthKitViewModel())
}

