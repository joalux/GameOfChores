//
//  CarouselView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-10-18.
//

import SwiftUI

struct CarouselView: View {
    
    @GestureState private var dragState = DragState.inactive
    @State var carouselLocation = 0
    
    var itemHeight: CGFloat
    var views: [AnyView]
    
    private func onDragEnded(drag: DragGesture.Value) {
        print("Drag ended!!")
        let dragThreshold: CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            carouselLocation = carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold) {
            carouselLocation = carouselLocation + 1
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(dragState.translation.width)")
                Text("Carousel location\(carouselLocation)")
                Text("Relative location\(getRelativeLoc())")
                Text("\(getRelativeLoc()) / \(views.count-1)")
                Spacer()
            }
            
            VStack {
                ZStack {
                    ForEach(0..<views.count){i in
                        VStack {
                            
                            Spacer()
                            self.views[i]
                            .frame(width:320, height: self.getHeight(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: 1)
                                .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                                
                            .opacity(self.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: 1)
                            .offset(x: self.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: 1)
                            Spacer()
                            
                        }
                    }
                }.gesture(
                    DragGesture()
                        .updating($dragState, body: { drag, state, transaction in
                            state = .dragging(translation: drag.translation)
                        })
                        .onEnded(onDragEnded)
                )
            }
        }
    }
    
    func getRelativeLoc() -> Int {
        return ((views.count * 1000) + carouselLocation) % views.count
    }
    
    func getHeight(_ i: Int) -> CGFloat {
        if i == getRelativeLoc() {
            return itemHeight
        } else {
            return itemHeight - 50
        }
    }
    
    func getOpacity(_ i:Int) -> Double {
        
        if i == getRelativeLoc()
            || i + 1 == getRelativeLoc()
            || i - 1 == getRelativeLoc()
            || i + 2 == getRelativeLoc()
            || i - 2 == getRelativeLoc()
            || (i + 1) - views.count == getRelativeLoc()
            || (i - 1) + views.count == getRelativeLoc()
            || (i + 2) - views.count == getRelativeLoc()
            || (i - 2) + views.count == getRelativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    func getOffset(_ i: Int) -> CGFloat {
        
        //Centre location
        if i == getRelativeLoc() {
            return self.dragState.translation.width
        }
        
        //Offsets of +/- 1
        else if i == getRelativeLoc() + 1 || getRelativeLoc() == views.count - 1 && i == 0 {
            //set offset +1
            return self.dragState.translation.width + (300 + 30)
        }
        else if i == getRelativeLoc() - 1 || getRelativeLoc() == views.count - 1 && i == 0 {
            //set offset -1
            return self.dragState.translation.width - (300 + 30)
        }
        
        //Offsets of +/- 2
        else if i == getRelativeLoc() + 2  || getRelativeLoc() == views.count - 1 && i == 1 || getRelativeLoc() == views.count - 2 && i == 0{
            //set offset +2
            return self.dragState.translation.width + (2 * (300 + 30))
        }
        else if i == getRelativeLoc() - 2 || getRelativeLoc() == 1 && i == views.count - 1 || getRelativeLoc() == 0 && i == views.count - 2 {
            //set offset +2
            return self.dragState.translation.width - (2 * (300 + 30))
        }
        
        //Offsets of +/- 3
        else if i == getRelativeLoc() + 3 || getRelativeLoc() == views.count - 1 && i == 2 || getRelativeLoc() == views.count - 2 && i == 1 || getRelativeLoc() == views.count - 3 && i == 0 {
            return self.dragState.translation.width + (3 * (300 + 20))
        }
        else if i == getRelativeLoc() - 3 || getRelativeLoc() == views.count - 1 && i == 2 || getRelativeLoc() == views.count - 2 && i == 1 || getRelativeLoc() == views.count - 3 && i == 0 {
            return self.dragState.translation.width + (3 * (300 + 20))

        }
        
        else {
            return 10000
        }
        
    }
}


enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
