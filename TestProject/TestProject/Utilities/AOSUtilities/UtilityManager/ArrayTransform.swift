import Foundation
import ObjectMapper
import RealmSwift


/// Description : This class is used for convert List to array of objects
class RealmListTransform<T:Object> : TransformType where T:Mappable {

    typealias Object = List<T>
    typealias JSON = [[String: Any]]

    let mapper = Mapper<T>()

    func transformFromJSON(_ value: Any?) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as? [Any] {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(JSONObject: entry)!
                result.append(model)
            }
        }
        return result
    }

    func transformToJSON(_ value: Object?) -> JSON? {
        var results = [[String:Any]]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}
extension RealmCollection {
  func toArray<T>() ->[T] {
    return self.compactMap{$0 as? T
    }
  }
}

public struct StringArrayTransform: TransformType {

    public init() { }

    public typealias Object = List<String>
    public typealias JSON = [String]

    public func transformFromJSON(_ value: Any?) -> List<String>? {
        guard let value = value else {
            return nil
        }
        let objects = value as! [String]
        let list = List<String>()
        list.append(objectsIn: objects)
        return list
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.toArray()
    }

}
