import UIKit

public enum ImageDataSource: Identifiable {
    case url(URL?)
    case uiImage(UIImage)
    
    public var id: String {
        switch self {
        case .url(let url):
            return url?.absoluteString ?? "unexpected url"
        case .uiImage(let uiImage):
            return String(UInt(bitPattern: ObjectIdentifier(uiImage)))
        }
    }
}
