//
//  ContentView.swift
//  Bullseye
//
//  Created by Abdinasir Muhumed on 11/14/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //States
    @State var alertIsVisible  = false
    @State var sliderValue  = 50.0
    @State var targetValue = Int.random(in: 1...100)
    @State var score = 0
    @State var currentRound = 1
    
    //Content
    var body: some View {
        HStack {
            HStack {
                VStack {
                    Spacer()
                    
                    //Titl Raw
                    HStack {
                        Text("Put the bullseye as close as you can to: ")
                        Text("\(targetValue)")
                    }
                    Spacer()
                    
                    //Slider raw
                    HStack {
                        Text("1")
                        Slider(value: $sliderValue, in: 1...100)
                        Text("100")
                    }
                    Spacer()
                    
                    //Button raw
                    Button(action: {
                        print("Button pressed")
                        self.alertIsVisible = true
                    }) {
                        Text("Hit Me!")
                    }
                        
                    .alert(isPresented: $alertIsVisible) { () -> Alert in
                        return Alert(title: Text(self.alertTitle()), message: Text("The slider's value is \(sliderValueRounded()) \n" +
                            "Your score is \(pointsForCurrentRound())"), dismissButton: .default(Text("Awesome!")) {
                                self.score = self.sliderValueRounded()
                                self.targetValue = Int.random(in: 1...100)
                                self.currentRound += 1
                            })
                    }
                    
                    Spacer()
                    //Score row
                    HStack {
                        Button(action : {}){
                            Text("Start Over")
                        }
                        Spacer()
                        Text("Score:")
                        Text(String(score))
                        Spacer()
                        Text("Round:")
                        Text("\(currentRound)")
                        Spacer()
                        Button(action: {}){
                            Text("Info")
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    func pointsForCurrentRound() -> Int{
        var result = abs(self.targetValue - sliderValueRounded())
        if result < 0 {
            result = -result
        }
        return result
    }
    
    func sliderValueRounded() -> Int{
        Int(self.sliderValue.rounded())
    }
    
    func alertTitle() -> String{
        let result : String
        switch pointsForCurrentRound() {
        case 0:
            result = "Perfect"
        case 1...5 :
            result = "You almost had it "
        case 1...10 :
            result = "Not bad!"
        default:
            result = "You are off"
        }
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
