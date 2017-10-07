import UIKit

enum DayOfWeek: String {
    case monday = "mon"
    case tuesday = "tue"
    case wednesday = "wed"
    case thursday = "thu"
    case friday = "fri"
    case saturday = "sat"
    case sunday = "sun"
}

struct Gathering {
    let id: String
    var name: String? = nil
    var doy: DayOfWeek? = nil
    var startTime: String? = nil
    var reminderTime: String? = nil
    
    init(id: String) {
        self.id = id
    }
}

class ChooseGatheringViewModel {
    var gatherings: [Gathering] = []
    var gatheringsRetrieved:(([Gathering]) -> Void)?
    
    init() {
        getListofAvailableGatherings()
    }
    
    func getListofAvailableGatherings() {
        DB.campus?.observeSingleEvent(of: .value) { [unowned self] (snapshot) in
            guard let root = snapshot.value as? [String : AnyObject] else { return }
            guard let gatherings = root["gatherings"] as? [String : Bool ] else { return }
            let listOfGatherings = Array(gatherings.keys)
            self.getHumanReadbleListOfGatherings(listOfGatherings)
        }
    }
    
    func getHumanReadbleListOfGatherings(_ gatherings: [String]) {
        DB.gatherings?.observeSingleEvent(of: .value) { [unowned self] (snapshot) in
            let listOfAllChurchGatherings = snapshot.value as? [String : AnyObject]
            let onlyCampusGatherings = listOfAllChurchGatherings?.filter({ (pair) -> Bool in
                return gatherings.contains(pair.key)
            })
            let parsedGatherings = self.parseFBGatherings(onlyCampusGatherings)
            self.gatherings = parsedGatherings
            self.gatheringsRetrieved?(parsedGatherings)
        }
    }
    
    func parseFBGatherings(_ fbGatherings: [String : AnyObject]?) -> [Gathering] {
        guard let fbGatherings = fbGatherings else { return [] }
        let parsedGatherings = fbGatherings.map { (fbGathering) -> Gathering in
            var gathering = Gathering(id: fbGathering.key)
            guard let details = fbGathering.value as? [String : AnyObject] else { return gathering }
            
            if let name = details["name"] as? String {
                gathering.name = name
            }
            if let day = details["dayOfWeek"] as? String {
                if let doy = DayOfWeek(rawValue: day) {
                    gathering.doy = doy
                }
            }
            if let startTime = details["startTime"] as? String {
                gathering.startTime = startTime
            }
            if let reminderTime = details["reminderTime"] as? String {
                gathering.reminderTime = reminderTime
            }
            return gathering
        }
        return parsedGatherings
    }
}
