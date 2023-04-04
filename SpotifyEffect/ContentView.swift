//
//  ContentView.swift
//  SpotifyEffect
//
//  Created by EdgardVS on 3/04/23.
//

import SwiftUI

//preference key que permitira monitorear los cambios en el geometry reader
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

//extension View {
//    func onScrollViewOffsetChanged(action: @escaping (_ offset: CGFloat) -> Void) -> some View {
//        self
//            .background(
//                GeometryReader{ geo in
//                Text("").preference(key: ScrollViewOffsetPreferenceKey.self ,value: geo.frame(in: .global).minY)
//            }
//            ).onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//                action(value)
//            }
//    }
//}

struct ContentView: View {
    
    let title: String = "My Music"
    @State private var scrollViewOffset: CGFloat = 0
    
    
    var body: some View {
        VStack {
            //imagen varia de acuerdo al offset
            Image(uiImage: UIImage(named: "album")!).resizable().frame(width: scrollViewOffset/1.5, height: scrollViewOffset/1.5)
            ScrollView {
                VStack {
                   
                    titleLayer
                        .opacity(Double(scrollViewOffset) / 75.0)
                        .background(
                            GeometryReader{ geo in
                                //el valor de la preference key sera el valor del geometry reader
                                //en este la posicion del texto con respecto  toda la pantalla, por eso el global
                                Text("").preference(key: ScrollViewOffsetPreferenceKey.self ,value: geo.frame(in: .global).minY)
                            })
                    contentLayer
                }.padding()
            }
            .overlay(Text("\(scrollViewOffset)"))
            //cada que cambia el valor de las preferencia se setea el valor de la vriable de estado
            //scrollViewOffset
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                scrollViewOffset = value
            }
            .overlay (navBarLayer.opacity(scrollViewOffset < 40 ? 1.0 : 0.0) ,alignment: .top)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}

extension ContentView {
    
    
    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentLayer: some View {
        ForEach(0..<10) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.3))
                .frame(width: 300, height: 200)
        }
    }
    
    private var navBarLayer: some View {
        ZStack {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
               
                //.background(Color.black)
                //.foregroundColor(.black)
                .zIndex(1)
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: .infinity, height: 55)
                
        }
            
    }
    
    
}
