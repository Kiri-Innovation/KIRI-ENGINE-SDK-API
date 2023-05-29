//
//  CameraContentView.swift
//  KIRIEngineSDK-Demo
//
//  Created by aria on 2023/4/26.
//

import SwiftUI
import KIRIEngineSDK

struct CameraContentView: View {
    let cameraView = CameraView()
    var body: some View {
        VStack(spacing: 20) {
            UIViewPreview {
                cameraView
            }
            Button("开始预览") {
                cameraView.startPreview { result in
                    print("result:\(result)")
                }
            }
            Button("点击拍照") {
                cameraView.takePhoto()
            }
        }
        .padding()
        .onAppear {
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            cameraView.setPhotoFolderPath("\(docPath)/CameraKit")
        }
    }
}

struct CameraContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraContentView()
    }
}
