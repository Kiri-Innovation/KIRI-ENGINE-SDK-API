//
//  UIViewPreview.swift
//  Example
//
//  Created by aria on 2022/12/28.
//

import SwiftUI

public struct UIViewPreview<V: UIView>: UIViewRepresentable {

  public let builder: () -> V

  public init(builder: @escaping () -> V) {
    self.builder = builder
  }

  public func makeUIView(context: Context) -> some UIView { builder() }
  public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

public struct UIViewControllerPreview<VC: UIViewController>: UIViewControllerRepresentable {

  public let builder: () -> VC

  public init(builder: @escaping () -> VC) {
    self.builder = builder
  }

  public func makeUIViewController(context: Context) -> VC { builder() }
  public func updateUIViewController(_ uiViewController: VC, context: Context) {}
}
