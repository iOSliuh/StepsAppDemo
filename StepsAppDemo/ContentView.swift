//
//  ContentView.swift
//  StepsAppDemo
//
//  Created by liuhao on 17/10/2023.
//

import SwiftUI

struct ContentView: View {
    let vieWModel = HealthKitViewModel()
    
    var body: some View {
        NavigationStack {
                TabView {
                    TargetView()
                        .tabItem {
                            VStack {
                                Image(systemName: "target")
                                Text(Constants.titleTabTarget)
                            }
                        }
                    StepsView(viewModel: vieWModel)
                        .tabItem {
                            VStack {
                                Image(systemName: "figure.walk.circle")
                                Text(Constants.titleTabStepCount)
                                    .foregroundColor(.mainColor)
                            }
                        }
                    ResultView()
                        .tabItem {
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                Text(Constants.titleTabResult)
                            }
                        }
                }
                .accentColor(.mainColor)
        }
    }
}

extension ContentView {
    func goToSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                
            }
        }
    }
}

#Preview {
    ContentView()
}
