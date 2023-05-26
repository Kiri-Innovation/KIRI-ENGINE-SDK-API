//
//  AdvanceContentView.swift
//  KIRIEngineSDK-Demo
//
//  Created by aria on 2023/4/26.
//

import SwiftUI
import KIRIEngineSDK

struct AdvanceContentView: View {
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

struct AdvanceContentView_Previews: PreviewProvider {
    static var previews: some View {
        AdvanceContentView()
    }
}
