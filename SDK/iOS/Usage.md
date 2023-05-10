# Using KIRIEngineSDK

## BasicCamera
### 1.使用KIRIEngineSDK时，先使用KIRISDK.share.setup初始化鉴权
```swift
KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
    print("result:\(result)")
}
```
### 2.初始化CameraView
```swift
let cameraView = CameraView()
```
### 3.使用setPhotoFolderPath设置自定义图片路径
```swift
let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
cameraView.setPhotoFolderPath("\(docPath)/KIRIEngineSDK")
```
### 4.调用startPreview开始请求权限并显示画面
```swift
cameraView.startPreview { result in
    print("result:\(result)")
}
```
### 5.调用takePhoto开始拍照
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
          KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
                print("result:\(result)")
            }
          let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
          cameraView.setPhotoFolderPath("\(docPath)/KIRIEngineSDK")
      }
    }
}

```

## AdvanceCamera

### 1.使用KIRIEngineSDK时，先使用KIRISDK.share.setup初始化鉴权
```swift
KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
    print("result:\(result)")
}
```
### 3.初始化CameraView
```swift
let cameraView = CameraView<AdvanceImageCaptureModel>()
```
### 4.使用setPhotoFolderPath设置自定义图片路径
```swift
let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
cameraView.setPhotoFolderPath("\(docPath)/KIRIEngineSDK")
```
### 5.调用startPreview开始请求权限并显示画面
```swift
cameraView.startPreview { result in
    print("result:\(result)")
}
```
### 6.调用takePhoto开始拍照
```swift
cameraView.takePhoto()
```

### 首先需要开启Advance
```swift
class AdvanceImageCaptureModel {
    ...
    public var isOpenAdvance: Bool
    ...
}
```

### 设置EV值
```swift
class AdvanceImageCaptureModel {
    ...
    public var evValue: CGFloat
    ...
}
```

### 设置ISO值
```swift
class AdvanceImageCaptureModel {
    ...
    public var isoValue: KiriAdvanceCameraKit.AdvanceImageCaptureModel.ValueType<CGFloat>
    ...
}
```
- iso的设置有两种方式，一个是auto自动调节iso的值来达到设置EV值的效果，二是指定ISO不在变化

### 设置快门值
```swift
class AdvanceImageCaptureModel {
    ...
    public var shutterValue: KiriAdvanceCameraKit.AdvanceImageCaptureModel.ValueType<CGFloat>
    ...
}
```
- 快门的设置同ISO

### 获取ISO值的变化
```swift
class AdvanceImageCaptureModel {
    ...
    public let isoValueSubject: PassthroughSubject<CGFloat, Never>
    ...
}
```
- 使用isoValueSubject来实时监听ISO值的变化

### 获取快门值的变化
```swift
class AdvanceImageCaptureModel {
    ...
    public let shutterSubject: PassthroughSubject<CGFloat, Never>
    ...
}
```
- 使用shutterSubject来实时监听快门值的变化

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
                Button("开始预览") {
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
                Button("点击拍照") {
                    cameraView.takePhoto()
                }
            }
            .padding()
            if isDeviceAvailability, let device = cameraView.captureModel.device {
                HStack {
                    Button("开启advance相机") {
                        isOpenAdvance = true
                    }
                    .disabled(isOpenAdvance)
                    Spacer()
                    Button("关闭advance相机") {
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
            KIRISDK.share.setup(envType: .test, appKey: "appkey") { result in
                print("result:\(result)")
            }

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
### 2.初始化CameraView
```swift
let sceneView = SceneView(frame: .zero)
```

### Example
```swift
import SwiftUI
import KIRIEngineSDK

...
使用SceneView之前先初始化
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