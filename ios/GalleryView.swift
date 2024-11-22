import SwiftUI
import Photos
import React

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
      
        if let predefinedColor = UIColor.colorFromName(hexSanitized) {
            self.init(cgColor: predefinedColor.cgColor)
            return
        }
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
  
    private static func colorFromName(_ name: String) -> UIColor? {
        let predefinedColors: [String: UIColor] = [
            "black": .black,
            "white": .white,
            "red": .red,
            "green": .green,
            "blue": .blue,
            "yellow": .yellow,
            "gray": .gray,
            "orange": .orange,
            "purple": .purple,
            "brown": .brown,
            "cyan": .cyan,
            "magenta": .magenta,
            "clear": .clear,
            "pink": .systemPink
        ]
        return predefinedColors[name]
    }
}

// Модель данных для представления изображения
struct MediaData: Identifiable {
    let id: String
    let creationDate: String?
    let image: UIImage
    let imageURL: String?
    let originalHeight: Int
    let originalWidth: Int

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "creationDate": creationDate ?? "",
            "imageURL": imageURL ?? "",
            "originalHeight": originalHeight,
            "originalWidth": originalWidth
        ]
    }
}

// Модель для стилей мультивыбора
struct MultiSelectStyle {
    var mainColor: UIColor
    var subColor: UIColor
}

let columnsCount = 3
let spacing: CGFloat = 1
let screenWidth = UIScreen.main.bounds.width
let itemWidth = (screenWidth - (CGFloat(columnsCount - 1) * spacing)) / CGFloat(columnsCount)
@available(iOS 14.0, *)
let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount)

@available(iOS 14.0, *)
struct GalleryView: View {
    @State private var images: [MediaData] = [] // Массив изображений
    @State private var isLoading = true       // Состояние загрузки
    @State private var isPermisionsGranted = true
    var onSelectMedia: (MediaData) -> Void
  
    // MultiSelect
    @State var selectedMedia: [MediaData] = [] // Используем MediaData напрямую
    var isMultiSelectEnabled: Bool
    var multiSelectStyle: MultiSelectStyle

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Загрузка фотографий...")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(images) { media in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: media.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: itemWidth, height: itemWidth)
                                    .contentShape(Rectangle())
                                    .clipped()
                                    .onTapGesture {
                                        handleSelection(media: media)
                                    }

                                // Индикатор выбора
                                if isMultiSelectEnabled {
                                    ZStack {
                                        Circle()
                                        .fill(selectedMedia.contains(where: { $0.id == media.id }) ? Color(multiSelectStyle.subColor) : Color.black.opacity(0.5))
                                            .frame(width: 24, height: 24)
                                            .overlay(Circle().stroke(Color(multiSelectStyle.mainColor), lineWidth: 2))
                                        
                                        if let index = selectedMedia.firstIndex(where: { $0.id == media.id }) {
                                            Text("\(index + 1)")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(multiSelectStyle.mainColor))
                                        }
                                    }
                                    .padding(5)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadPhotos)
    } 

    private func loadPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 300, height: 300)
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .highQualityFormat
                requestOptions.isSynchronous = false
                
                var loadedMediaItems: [MediaData] = []
                var completedRequests = 0
                
                fetchResult.enumerateObjects { asset, _, _ in
                    asset.requestContentEditingInput(with: nil) { contentEditingInput, _ in
                        if let url = contentEditingInput?.fullSizeImageURL {
                            // Запрашиваем изображение для отображения в миниатюре
                            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, info in
                                if let image = image, info?[PHImageResultIsDegradedKey] as? Bool == false {
                                    let dateFormatter = ISO8601DateFormatter()
                                    let creationDateString = asset.creationDate.map { dateFormatter.string(from: $0) }
                                    let mediaData = MediaData(
                                        id: asset.localIdentifier,
                                        creationDate: creationDateString,
                                        image: image,
                                        imageURL: url.absoluteString,
                                        originalHeight: asset.pixelHeight,
                                        originalWidth: asset.pixelWidth
                                    )
                                    loadedMediaItems.append(mediaData)
                                }
                                completedRequests += 1
                                
                                // Проверяем, завершены ли все запросы
                                if completedRequests == fetchResult.count {
                                    DispatchQueue.main.async {
                                      self.images = loadedMediaItems.sorted { $0.creationDate ?? "" > $1.creationDate ?? "" }
                                      self.isLoading = false
                                    }
                                }
                            }
                        } else {
                            completedRequests += 1
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isPermisionsGranted = false
                    self.isLoading = false
                }
            }
        }
    }
  
    private func handleSelection(media: MediaData) {
        if isMultiSelectEnabled {
            if let index = selectedMedia.firstIndex(where: { $0.id == media.id }) {
                selectedMedia.remove(at: index)
            } else {
                selectedMedia.append(media)
            }
            onSelectMedia(media)
        } else {
            onSelectMedia(media)
        }
    }
}
