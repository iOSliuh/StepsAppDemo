//
//  StepsView.swift
//  StepsAppDemo
//
//  Created by liuhao on 17/10/2023.
//

import SwiftUI


struct StepsView: View {
    @ObservedObject var viewModel: HealthKitViewModel
    
    let timeArray = Constants.titlesTabsStepview
    @State var tabSwitch = 0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                   
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.mainColor)
                        .font(Font.system(size: 20))
                })
                Spacer()
                
                ForEach(timeArray.indices, id: \.self) { i in
                    Button {
                        withAnimation {
                            tabSwitch = i
                        }
                    } label: {
                        VStack {
                            Text(timeArray[i])
                            if tabSwitch == i {
                                Spacer().frame(height: 5)
                                Rectangle.init().foregroundColor(.mainColor).frame(width: 20, height: 2.0)
                            }
                        }
                    }
                    .foregroundColor(tabSwitch == i ? .black: .dateGray)
                    .padding(15)
                    .font(Font.system(size: 16, weight: tabSwitch == i ? .bold : .regular))
                }
                Spacer()
                
                Button (action: {
                    
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.mainColor)
                        .font(Font.system(size: 20, weight: .semibold))
                })
            }
            
            TabView (selection: $tabSwitch) {
                DayView(viewModel: viewModel).tag(0)
                WeekView().tag(1)
                MonthView().tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).ignoresSafeArea()
        }.padding()
    }
}

#Preview {
    StepsView(viewModel: HealthKitViewModel())
}

