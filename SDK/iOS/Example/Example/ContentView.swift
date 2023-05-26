//
//  ContentView.swift
//  KIRIEngineSDK-Demo
//
//  Created by aria on 2023/4/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Camera Demo") {
                    CameraContentView()
                        .navigationTitle("Camera Demo")
                        .navigationBarTitleDisplayMode(.inline)
                }
                
                NavigationLink("Advance Camera Demo") {
                    AdvanceContentView()
                        .navigationTitle("Advance Camera Demo")
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("Video Demo") {
                    VideoCaptureContentView()
                        .navigationTitle("Video Demo")
                        .navigationBarTitleDisplayMode(.inline)
                }

            }
            .navigationTitle("KIRIEngineSDK-Demo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
