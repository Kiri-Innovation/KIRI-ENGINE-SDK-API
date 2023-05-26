//
//  VideoCaptureContentView.swift
//  KIRIEngineSDK-Demo
//
//  Created by aria on 2023/5/25.
//

import SwiftUI
import KIRIEngineSDK
import AVKit

class VideoCaptureProxy: VideoCaptureVCDelegate {
    
    var finishRecordingClosure: ((URL, Error?) -> Void)?
    
    init() { }
     
    func videoCapture(_ vc: KIRIEngineSDK.VideoCaptureVC, didFinishRecording outputFileURL: URL, error: Error?) {
        finishRecordingClosure?(outputFileURL, error)
    }
    
}

struct VideoCaptureContentView: View {
    let vc = VideoCaptureVC()!
    let proxy = VideoCaptureProxy()
    @State
    var isPresented = false
    @State
    var fileURL: URL?
    @State
    var isShowMessage = false
    @State
    var message: String?
    @State
    var isShowError = false
    @State
    var error: Error?
    
    init() {
        vc.delegate = proxy
    }
    
    var body: some View {
        VStack {
            UIViewControllerPreview {
                vc
            }
            Text("")
                .alert(isPresented: $isShowMessage) {
                    Alert(
                        title: Text("\(message ?? "")"),
                        dismissButton: .cancel()
                    )
                }
            Text("")
                .alert(isPresented: $isShowError) {
                    Alert(
                        title: Text("\(error?.localizedDescription ?? "")"),
                        dismissButton: .cancel()
                    )
                }
        }
        .onAppear {
            proxy.finishRecordingClosure = { fileURL, error in
                DispatchQueue.main.async {
                    self.fileURL = fileURL
                    self.isPresented = true
                }
            }
        }
        .actionSheet(isPresented: $isPresented) {
            ActionSheet(
                title: Text("video file url"),
                message: Text("\(self.fileURL?.path ?? "")"),
                buttons: [
                    .default(
                        Text("Preview"),
                        action: {
                            openVideoWithURL()
                        }
                    ),
                    .default(
                        Text("Check"),
                        action: {
                            checkVideo()
                        }
                    ),
                    .cancel(Text("Cancel"))
                ]
            )
        }
        
    }
    
    func openVideoWithURL() {
        guard let url = self.fileURL else { return }
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: url)
        playerViewController.player = player
        UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    func checkVideo() {
        guard let url = self.fileURL else { return }
        do {
            try VideoTools.checkVideoFile(url)
            message = "Check success"
            isShowMessage = true
        } catch {
            self.error = error
            isShowError = true
            print("error:\(error)")
        }
    }
}

struct VideoCaptureContentView_Previews: PreviewProvider {
    static var previews: some View {
        VideoCaptureContentView()
    }
}
