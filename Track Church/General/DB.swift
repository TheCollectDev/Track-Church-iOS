import Foundation
import Firebase

class DB {
    var church: String?
    var campus: String?
    
    private lazy var reference: DatabaseReference = {
        return Database.database().reference()
    }()
    
    private static let shared: DB = {
        return DB()
    }()
    
    class var users: DatabaseReference {
        return DB.shared.reference.child("users")
    }
    
    class var campus: DatabaseReference? {
        guard let church = DB.shared.church, let campus = DB.shared.campus else { return nil }
        return DB.shared.reference.child("campuses").child(church).child(campus)
    }
    
    class var campuses: DatabaseReference? {
        guard let church = DB.shared.church else { return nil }
        return DB.shared.reference.child("campuses").child(church)
    }
    
    class var gatherings: DatabaseReference? {
        guard let church = DB.shared.church else { return nil }
        return DB.shared.reference.child("gatherings").child(church)
    }
    
    class var metrics: DatabaseReference? {
        guard let church = DB.shared.church else { return nil }
        return DB.shared.reference.child("metrics").child(church)
    }
    
    class func setChurch(_ church: String) {
        DB.shared.church = church
    }
    
    class func setCampus(_ campus: String) {
        DB.shared.campus = campus
    }
}
