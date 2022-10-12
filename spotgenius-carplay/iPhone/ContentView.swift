//
//  ContentView.swift
//  spotgenius-carplay
//
//
//  Created by Jacob Curtis on 09/08/2022.
//

import SwiftUI
import Flutter

struct ContentView: View {
    var body: some View {
        Text("SpotGenius CarPlay").onTapGesture {
            print("onTap SpotGenius CarPlay")
//            showFlutter()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
