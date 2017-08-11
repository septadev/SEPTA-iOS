// Septa. 2017

import Foundation
import SeptaSchedule

enum UserPreferenceKeys: String {
    case preferredTransitMode
    case favorites

    func defaultValue() -> String? {
        switch self {
        case .preferredTransitMode:
            return TransitMode.rail.rawValue
        default:
            return nil
        }
    }
}
