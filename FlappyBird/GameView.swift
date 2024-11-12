import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject private var game = GameScene()

    var body: some View {
        ZStack {
           
            SpriteView(scene: game)
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

           
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: ContentView(),
                        label: {
                            Text(" Menu")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                }
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewLayout(.fixed(width: 812, height: 375))
    }
}


