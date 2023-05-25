//
//  CircleProgressBar.swift
//  Ongry
//
//  Created by Andrew Chang on 4/1/23.
//

import SwiftUI

struct CircleContentView: View
{
    @State var progressValue: Float = 0.0
    var body: some View
    {
        CircleProgressBar(progress: self.progressValue)
            .frame(width: 160, height: 160)
            .onAppear(){
                self.progressValue = 0.0
            }
    }
}

struct CircleProgressBar: View
{
    var progress: Float
    var color: Color = Color("Green")
    var body: some View
    {
        ZStack
        {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.2)
                .foregroundColor(Color("Background"))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("Green"))
                .rotationEffect(Angle(degrees: 90))
            
            VStack
            {
                Text("Protein")
                    .bold()
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(.white)
                Text("50g")
                    .bold()
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct CircleProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircleContentView()
    }
}
