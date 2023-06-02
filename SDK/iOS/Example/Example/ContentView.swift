//
//  ContentView.swift
//  KIRIEngineSDK-Demo
//
//  Created by aria on 2023/4/26.
//

import SwiftUI
import KIRIEngineSDK

struct ContentView: View {
  @State
  var isAuthorization = false
  
  var body: some View {
    VStack {
      if isAuthorization {
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
        
      } else {
        
      }
    }
    .onAppear {
      KIRISDK.share.setup(envType: .test, appKey: "8dc8f5321f6325c55c649409342e7af6") { result in
        print("result:\(result)")
        switch result {
        case .success:
          isAuthorization = true
        case .failure:
          isAuthorization = false
        }
      }
    }
  }
}
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
