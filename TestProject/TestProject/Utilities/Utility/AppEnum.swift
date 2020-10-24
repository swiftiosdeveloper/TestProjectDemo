

import UIKit

enum AppModeOn {
    case dev, sit, uat, live
    var currentURL: String {
        switch self {
        case .dev:
            return  ".development"
        case .sit:
            return ".sit"
        case .uat:
            return ".uat"
        case .live:
            return ".live"
        }
    }
    var baseURL: String {
        switch self {
        case .dev:
        case .sit:
        case .uat:
        case .live:
        }
    }
    var baseImageURL: String {
        switch self {
        case .dev:
        case .sit:
        case .uat:
        case .live:
        }
    }
    var mapURL: String {
        switch self {
        case .dev:
        case .sit:
        case .uat:
        case .live:
        }
    }
}
