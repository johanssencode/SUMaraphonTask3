//
//  SUMaraphonTask3App.swift
//  SUMaraphonTask3
//
//  Created by A on 05.12.2024.
//

import SwiftUI

@MainActor
struct PlayForwardButton: View {
    
    //MARK: Settings States
    
    let animationReps = 4 // Повторяем 4 раза на одном тапе
    let cycleDuration: Double = 0.5 // Длительность цикла в секундах
    let elementWidth: CGFloat = 40 // Размер элемента (ширина = высота)
    let elementSFSymbolName: String =  "arrowtriangle.forward.fill" // код элемента из SFSymbols библиотеки
    let elementColor: Color = .blue
  
    
    //MARK: States
    @State var isAnimating = false
    @State var animationCount = 0
   
    @State var opacities = [0.2, 1.0, 1.0]
    @State var scales = [0.1, 1.0, 1.0]
    
    @State var offset: CGFloat = 0

    var body: some View {
        
        Button {
            
            startAnimation()
       
        } label: {
            
            HStack(spacing: 0) {
 
                ForEach(0..<3) { index in
                    
                    Image(systemName: elementSFSymbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: elementWidth, height: elementWidth)
                        .foregroundStyle(elementColor)
                        .opacity(opacities[index])
                        .scaleEffect(scales[index])
                    
                }
            }//:HStack
            .offset(x: offset)
            
        }//: Button
        .frame(width: elementWidth * 2, height: elementWidth)
        .offset(x: -elementWidth/2)
        .buttonStyle(.plain)
        .clipped()
        //.border(.red) // граница
    }
    

    func startAnimation() {
        
        guard !isAnimating else { return } // чтобы не прерывать текущую анимацию во время повторного тапа
  
        isAnimating = true
        animationCount = 0
        animate()
   
    }

    func animate() {
       
        // остановим если превысили заданное число циклов
        guard animationCount < animationReps else {
           
            isAnimating = false // останавливаем анимацию
            return
       
        }
        
        // Можно попробовать другие виды анимаций но .spring(.smooth) смотрится достойно
        withAnimation(.spring(.smooth)) {
           
            // оффсет HStack на размер элемента
            offset = elementWidth
  
            opacities[0] = 1.0 // Появляется 1 элемент
            scales[0] = 1.0 // Растет 1 элемент
            opacities[2] = 0.0 // Исчезает 3 элемент
            scales[2] = 0.1 // Уменьшается 3 элемент
          
        }
        
        Task {
            try? await Task.sleep(for: .seconds(cycleDuration))
           
            offset = 0
            opacities = [0.2, 1.0, 1.0]
            scales = [0.1, 1.0, 1.0]
            animationCount += 1
            animate() // повтор цикла
            
        }
    }
}


#Preview {
    
    PlayForwardButton()
    
}
