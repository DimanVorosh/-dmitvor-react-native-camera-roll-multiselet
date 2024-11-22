import React

@available(iOS 14.0, *)
@objc(GalleryViewManager)
class GalleryViewManager: RCTViewManager {
    override func view() -> UIView! {
        return GalleryViewWrapper()
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
  
    @objc func setMultiSelectEnabled(_ enabled: NSNumber, forView view: UIView) {
        guard let galleryView = view as? GalleryViewWrapper else { return }
        galleryView.isMultiSelectEnabled = enabled.boolValue
        galleryView.selectedMedia = []
    }
  
    @objc func getSelectedMedia(_ viewTag: NSNumber, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let view = self.bridge.uiManager.view(forReactTag: viewTag) as? GalleryViewWrapper else {
                rejecter("E_VIEW_NOT_FOUND", "View not found", nil)
                return
            }

            let selectedMedia = view.getSelectedMedia()
            resolver(selectedMedia)
        }
    }
}
