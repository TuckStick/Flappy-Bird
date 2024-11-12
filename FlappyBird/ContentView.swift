//
//  ContentView.swift
//  FlappyBird
//
//  Created by AM Student on 11/6/24.
//

// STOPED VIDEO AT 4 MINS pt 3

import SwiftUI

struct ContentView: View {
    let farben = [Color("Color"), Color("Color1")]
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    Text("Simga Bird")
                        .font(.custom("Chalkduster", size: 32))
                    Spacer()
                    
                   
                    Image("frame-2")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Spacer()
                    
                    NavigationLink(
                        destination: GameView(),
                        label: {
                            Text("Start Game")
                                .font(.custom("Chalkduster", size: 22))
                                .foregroundColor(.black)
                            
                        })
                    Spacer()
                }

            }
            .frame(width: 950, height: 440, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: farben), startPoint: .bottom,
                    endPoint: .top)
            )

            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 950, height: 420))
    }
}
