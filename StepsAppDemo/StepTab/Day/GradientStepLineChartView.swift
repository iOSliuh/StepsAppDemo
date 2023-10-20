//
//  GradientStepLineChartView.swift
//  StepsAppDemo
//
//  Created by liuhao on 20/10/2023.
//

import SwiftUI
import Charts

struct GradientStepLineChartView: View {
    @ObservedObject var viewModel: HealthKitViewModel

    let linearGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color.mainColor.opacity(
                    0.6
                ),
                Color.mainColor.opacity(
                    0
                )
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        Chart {
            ForEach( viewModel.steps ) { step in
                LineMark(x: .value("date", step.date),
                         y: .value("step", step.stepsCount))
            }
            .interpolationMethod(
                .catmullRom
            )
            .symbol(
                by: .value(
                    "Date",
                    "Step"
                )
            )
            ForEach( viewModel.steps ) { step in
                AreaMark(x: .value("date", step.date),
                         y: .value("step", step.stepsCount))
            }
            .interpolationMethod(
                .catmullRom
            )
            .foregroundStyle(
                linearGradient
            )
        }
        /*
        .chartXScale(
           // domain: 1998...2024
            
        )
        .chartLegend(
            .hidden
        )*/
        /*
        .chartXAxis {
            AxisMarks(
                values: [
                    2000,
                    2010,
                    2015,
                    2022
                ]
            ) { value in
                AxisGridLine()
                AxisTick()
                if let year = value.as(
                    Int.self
                ) {
                     AxisValueLabel(formatte(number: year),
                   // AxisValueLabel(LocalizedStringKey(year)
                     centered: false,
                     anchor: .top)
                }
            }
        }*/
        .chartXAxis {
            AxisMarks(position: .top)
        }
        .chartYAxis(.hidden)
 .padding()
 }
    
    let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    func formatte(number: Int) -> String {
        let result = NSNumber(value: number)
        return numberFormatter.string(from: result) ?? ""
    }
}
/*
#Preview {
    GradientStepLineChartView(viewModel: <#HealthKitViewModel#>)
}
*/
