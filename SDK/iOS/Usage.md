# Using KIRIEngineSDK

## BasicCamera
### 1.When using KIRIEngineSDK, use kirisdk.share-setup to initialize authentication
```swift
KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
    print("result:\(result)")
}
```
### 2.initialize CameraView
```swift
let cameraView = CameraView()
```
### 3.Use setPhotoFolderPath to set a custom image path
```swift
let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
cameraView.setPhotoFolderPath("\(docPath)/KIRIEngineSDK")
```
### 4.Call startPreview to start requesting permissions and display the screen
```swift
cameraView.startPreview { result in
    print("result:\(result)")
}
```
### 5.Call takePhoto to start taking the photo
```swift
cameraView.takePhoto()
```

### Example
```swift
import SwiftUI
import KIRIEngineSDK

struct ContentView: View {
    let cameraView = CameraView()
    var body: some View {
      VStack(spacing: 20) {
          UIViewPreview {
              cameraView
          }
          Button("Start preview") {
              cameraView.startPreview { result in
                  print("result:\(result)")
              }
          }
          Button("Click to take a photo") {
              cameraView.takePhoto()
          }
      }
      .padding()
      .onAppear {
          let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
          cameraView.setPhotoFolderPath("\(docPath)/KIRIEngineSDK")
      }
    }
}

```

## AdvanceCamera

### 1.When using KIRIEngineSDK, use kirisdk.share-setup to initialize authentication
```swift
KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
    print("result:\(result)")
}
```
### 2.initialize CameraView
```swift
let cameraView = CameraView<AdvanceImageCaptureModel>()
```
### 3.Use setPhotoFolderPath to set a custom image path
```swift
let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
cameraView.setPhotoFolderPath("\(docPath)/KIRIEngineSDK")
```
### 4.Call startPreview to start requesting permissions and display the screen
```swift
cameraView.startPreview { result in
    print("result:\(result)")
}
```
### 5.Call takePhoto to start taking the photo
```swift
cameraView.takePhoto()
```

### First, you need to enable Advance
```swift
class AdvanceImageCaptureModel {
    ...
    public var isOpenAdvance: Bool
    ...
}
```

### Set EV value
```swift
class AdvanceImageCaptureModel {
    ...
    public var evValue: CGFloat
    ...
}
```

### Set the ISO value
```swift
class AdvanceImageCaptureModel {
    ...
    public var isoValue: KiriAdvanceCameraKit.AdvanceImageCaptureModel.ValueType<CGFloat>
    ...
}
```
- There are two ways to set the iso, one is to automatically adjust the iso value to achieve the effect of setting the EV value, and the other is to specify that the ISO is not changing

### Set the shutter value
```swift
class AdvanceImageCaptureModel {
    ...
    public var shutterValue: KiriAdvanceCameraKit.AdvanceImageCaptureModel.ValueType<CGFloat>
    ...
}
```
- The shutter setting is the same as the ISO

### Gets the change in the ISO value
```swift
class AdvanceImageCaptureModel {
    ...
    public let isoValueSubject: PassthroughSubject<CGFloat, Never>
    ...
}
```
- Use isoValueSubject to listen for changes to the ISO value in real time

### Gets the change in the shutter value
```swift
class AdvanceImageCaptureModel {
    ...
    public let shutterSubject: PassthroughSubject<CGFloat, Never>
    ...
}
```
- Use shutterSubject to listen for changes in shutter values in real time

### Example
```swift
import SwiftUI
import KIRIEngineSDK

struct ContentView: View {
    let cameraView = CameraView<AdvanceImageCaptureModel>()
    @State
    var isDeviceAvailability = false
    @State
    var evValue: CGFloat = 0
    @State
    var inputIsoValue: CGFloat = 300
    @State
    var isoAuto: Bool = true
    @State
    var inputShutterValue: CGFloat = 0.03
    @State
    var shutterAuto: Bool = true
    @State
    var isOpenAdvance: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            UIViewPreview {
                cameraView
            }
            HStack {
                Button("Start preview") {
                    cameraView.startPreview { result in
                        print("result:\(result)")
                        switch result {
                        case .success(let status):
                            if status == .authorized {
                                isDeviceAvailability = true
                            }
                        case .failure:
                            break
                        }
                    }
                }
                Spacer()
                Button("Click to take a photo") {
                    cameraView.takePhoto()
                }
            }
            .padding()
            if isDeviceAvailability, let device = cameraView.captureModel.device {
                HStack {
                    Button("Turn on the advance camera") {
                        isOpenAdvance = true
                    }
                    .disabled(isOpenAdvance)
                    Spacer()
                    Button("Turn off the advance camera") {
                        isOpenAdvance = false
                    }
                    .disabled(!isOpenAdvance)
                }.padding()
                
                sliderItem(title: "ev", in: -3...3, minimumValueLabel: {
                    Text("-3")
                }, maximumValueLabel: {
                    Text("3")
                }, currentValue: $evValue, currentView: {
                    Text(String(format: "%.1f", evValue))
                })
                sliderItem(title: "iso", in: CGFloat(device.activeFormat.minISO)...CGFloat(device.activeFormat.maxISO), minimumValueLabel: {
                    Text("\(Int(CGFloat(device.activeFormat.minISO)))")
                }, maximumValueLabel: {
                    Text("\(Int(CGFloat(device.activeFormat.maxISO)))")
                }, currentValue: $inputIsoValue, currentView: {
                    Text("\(Int(inputIsoValue))")
                }, isCanAuto: $isoAuto)
                sliderItem(title: "shutter", in: device.activeFormat.minExposureDuration.time...device.activeFormat.maxExposureDuration.time, minimumValueLabel: {
                    Text("1/\(Int(1/device.activeFormat.minExposureDuration.time))")
                }, maximumValueLabel: {
                    Text("1/\(Int(1/device.activeFormat.maxExposureDuration.time))")
                }, currentValue: $inputShutterValue, currentView: {
                    Text("1/\(Int(1/inputShutterValue))")
                }, isCanAuto: $shutterAuto)
            }
        }
        .padding()
        .onChange(of: evValue) { newValue in
            cameraView.captureModel.evValue = newValue
        }
        .onChange(of: inputIsoValue) { newValue in
            if !isoAuto {
                cameraView.captureModel.isoValue = .value(newValue)
            }
        }
        .onChange(of: isoAuto, perform: { newValue in
            if newValue {
                cameraView.captureModel.isoValue = .auto
            } else {
                cameraView.captureModel.isoValue = .value(inputIsoValue)
            }
        })
        .onChange(of: inputShutterValue) { newValue in
            if !shutterAuto {
                cameraView.captureModel.shutterValue = .value(newValue)
            }
        }
        .onChange(of: shutterAuto, perform: { newValue in
            if newValue {
                cameraView.captureModel.shutterValue = .auto
            } else {
                cameraView.captureModel.shutterValue = .value(inputShutterValue)
            }
        })
        .onChange(of: isOpenAdvance) { newValue in
            cameraView.captureModel.isOpenAdvance = newValue
        }
        .onReceive(cameraView.captureModel.isoValueSubject, perform: { iso in
            if case .auto = cameraView.captureModel.isoValue {
                isoAuto = true
                inputIsoValue = iso
            } else {
                isoAuto = false
            }
        })
        .onReceive(cameraView.captureModel.shutterSubject, perform: { shutter in
            if case .auto = cameraView.captureModel.shutterValue {
                shutterAuto = true
                inputShutterValue = shutter
            } else {
                shutterAuto = false
            }
        })
        .onAppear {

            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            cameraView.setPhotoFolderPath("\(docPath)/CameraKit")
        }
    }
    
    func sliderItem<ValueView: View, CurrentView: View>(title: String, in bounds: ClosedRange<CGFloat>, @ViewBuilder minimumValueLabel: () -> ValueView, @ViewBuilder maximumValueLabel: () -> ValueView, currentValue: Binding<CGFloat>, @ViewBuilder currentView: () -> CurrentView,  isCanAuto: Binding<Bool>? = nil) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                currentView()
            }
            HStack {
                Slider(value: currentValue, in: bounds) {
                    Text("the value")
                } minimumValueLabel: {
                    minimumValueLabel()
                } maximumValueLabel: {
                    maximumValueLabel()
                }
                if let isCanAuto {
                    Spacer(minLength: 10)
                    Text("isAuto")
                    Toggle("", isOn: isCanAuto)
                        .frame(width: 60)
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

```

## 3DModelDisplay
### Initialize the CameraView
```swift
let sceneView = SceneView(frame: .zero)
```

### Example
```swift
import SwiftUI
import KIRIEngineSDK

...
Initialize before using SceneView
KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
    print("result:\(result)")
}
...

struct ContentView: View {
    let sceneView = SceneView(frame: .zero)
    
    var body: some View {
        VStack {
            UIViewPreview {
                sceneView
            }
        }
        .padding()
        .onAppear {
            sceneView.loadScene(modelUrl: Bundle.main.url(forResource: "3DModel", withExtension: "obj")!, textureUrl: Bundle.main.url(forResource: "3DModel", withExtension: "jpg")!)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


```

## VideoCapture
### 1.When using KIRIEngineSDK, use kirisdk.share-setup to initialize authentication
```swift
KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
    print("result:\(result)")
}
```
### Example Initialize VideoCaptureVC
```swift
/// - Parameters:
///   - folderPath: set video file save path
///   - minSecond: min record Second, If it is less than 3 seconds, the default value is 3 seconds
///   - maxSecond: max record Second, Longer than 2 minutes The default value is 2 minutes
public init?(folderPath: String? = nil, minSecond: Int = 3, maxSecond: Int = 60 * 2)
```

### Get a link to the shot video
```swift
videoCaptureVC.delegate = vc
实现方法来获取链接
func videoCapture(_ vc: KIRIEngineSDK.VideoCaptureVC, didFinishRecording outputFileURL: URL, error: Error?)
```

### Obtain the parameters of the video to be uploaded
```swift
class VideoTools {
...
public class func checkVideoFile(_ file: URL, completion: @escaping (Result<KIRIEngineSDK.VideoParameter, Error>) -> Void)
// or
public class func checkVideoFile(_ file: URL) async throws -> KIRIEngineSDK.VideoParameter
...
}
```

### Example
```swift
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
        VideoTools.checkVideoFile(url) { result in
            switch result {
            case .success(let success):
                message = "Check success"
                isShowMessage = true
            case .failure(let error):
                self.error = error
                isShowError = true
                print("error:\(error)")
            }
        }
    }
}

struct VideoCaptureContentView_Previews: PreviewProvider {
    static var previews: some View {
        VideoCaptureContentView()
    }
}

```
