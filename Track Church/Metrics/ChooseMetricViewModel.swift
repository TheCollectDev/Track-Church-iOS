import UIKit

enum MetricType: String {
    case number = "number"
    case list = "list"
}

struct Metric {
    let id: String
    var name: String? = nil
    var detail: String? = nil
    var type: MetricType? = nil
    
    init(id: String) {
        self.id = id
    }
}

class ChooseMetricViewModel {

    var gathering: Gathering
    var retrieved: Bool = false
    var metrics: [Metric] = []
    var metricsRetrieved: (([Metric]) -> Void)? {
        didSet {
            if retrieved {
                self.metricsRetrieved?(metrics)
            }
        }
    }
    
    init(forGathering gathering: Gathering) {
        self.gathering = gathering
        self.getListOfApplicableMetrics()
    }
    
    func getListOfApplicableMetrics() {
        DB.metrics?.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            let listOfAllMetrics = snapshot.value as? [String: AnyObject]
            guard let campusMetrics = self?.gathering.metrics else { return }
            let onlyCampusMetrics = listOfAllMetrics?.filter({ (pair) -> Bool in
                return campusMetrics.contains(pair.key)
            })
            guard let parsedMetrics = self?.parseFBMetrics(onlyCampusMetrics) else { return }
            self?.metrics = parsedMetrics
            self?.retrieved = true
            self?.metricsRetrieved?(parsedMetrics)
        })
    }
    
    func parseFBMetrics(_ fbMetrics: [String : AnyObject]?) -> [Metric] {
        guard let fbMetrics = fbMetrics else { return [] }
        let parsedMetrics = fbMetrics.map { (fbMetric) -> Metric in
            var metric = Metric(id: fbMetric.key)
            guard let details = fbMetric.value as? [String : AnyObject] else { return metric }
            
            if let name = details["name"] as? String {
                metric.name = name
            }
            if let detail = details["description"] as? String {
                metric.detail = detail
            }
            if let type = details["type"] as? String {
                if let metricType = MetricType(rawValue:type) {
                    metric.type = metricType
                }
            }
            return metric
        }
        return parsedMetrics
    }
}
