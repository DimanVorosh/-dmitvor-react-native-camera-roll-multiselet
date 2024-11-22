//
//  GalleryViewWrapper.swift
//  CameraRoll
//
//  Created by Дмитрий Ворошилло on 04.11.2024.
//

import Foundation
import SwiftUI
import UIKit
import React

@available(iOS 14.0, *)
class GalleryViewWrapper: UIView {
    @objc var onSelectMedia: RCTDirectEventBlock?
    @objc var isMultiSelectEnabled: Bool = false {
          didSet {
              selectedMedia = []
              updateGalleryView()
          }
      }
    @objc var multiSelectStyle: NSDictionary? { // Поддержка multiSelectStyle из React Native
        didSet {
            guard let style = multiSelectStyle else { return }
            if let mainColorHex = style["mainColor"] as? String,
               let subColorHex = style["subColor"] as? String {
                self._multiSelectStyle = MultiSelectStyle(
                    mainColor: UIColor(hex: mainColorHex) ?? .white,
                    subColor: UIColor(hex: subColorHex) ?? .blue
                )
                updateGalleryView()
            }
        }
    }
  
    private var _multiSelectStyle: MultiSelectStyle = MultiSelectStyle(mainColor: .white, subColor: .blue)

    private var hostingController: UIHostingController<GalleryView>?
    var selectedMedia: [MediaData] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGalleryView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureGalleryView() {
        let galleryView = makeGalleryView()

        hostingController = UIHostingController(rootView: galleryView)
        guard let hostingControllerView = hostingController?.view else { return }

        hostingControllerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingControllerView)

        NSLayoutConstraint.activate([
            hostingControllerView.topAnchor.constraint(equalTo: topAnchor),
            hostingControllerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingControllerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingControllerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func makeGalleryView() -> GalleryView {
          return GalleryView(
              onSelectMedia: { media in
                if self.isMultiSelectEnabled {
                  DispatchQueue.main.async {
                      if !self.selectedMedia.contains(where: { $0.id == media.id }) {
                          self.selectedMedia.append(media)
                      } else {
                          self.selectedMedia.removeAll { $0.id == media.id }
                      }
                  }
                }
                self.onSelectMedia?(media.toDictionary())
              },
              selectedMedia: selectedMedia,
              isMultiSelectEnabled: isMultiSelectEnabled,
              multiSelectStyle: _multiSelectStyle
          )
      }

      private func updateGalleryView() {
          hostingController?.rootView = makeGalleryView()
      }
  
      @objc func getSelectedMedia() -> [[String: Any]] {
          selectedMedia.map { $0.toDictionary() }
      }
}
