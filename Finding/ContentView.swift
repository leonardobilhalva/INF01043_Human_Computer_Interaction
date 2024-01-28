//
//  ContentView.swift
//  Finding
//
//  Created by Leonardo Bilhalva on 25/01/24.
//

import Foundation
import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var model = MyFindingModel.shared
    @State var isPresented = false
    
    var body: some View {
        Button("Select Apps to Discourage") {
            isPresented = true
        }
        .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)
        Button("Start Monitoring") {
            model.initiateMonitoring()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
