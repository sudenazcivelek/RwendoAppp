import Foundation

@Observable
class ModelData {
    var landmarks: [Landmark] = []
    var hikes: [Hike] = []
    var profile = Profile.default


    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }

    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }

    init() {
        self.landmarks = load_landmarks()
        self.hikes = load_hikes()
    }

    func load_landmarks() -> [Landmark] {
        var landmarks: [Landmark] = []
        let semaphore = DispatchSemaphore(value: 0)

        guard let url = URL(string: "http://127.0.0.1:5000/get_landmarks") else {
            print("Invalid URL for landmarks")
            return landmarks
        }

        print("Fetching landmarks...")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch landmarks: \(error.localizedDescription)")
                semaphore.signal()
                return
            }

            guard let data = data else {
                print("No data received for landmarks")
                semaphore.signal()
                return
            }

            do {
                let decoder = JSONDecoder()
                landmarks = try decoder.decode([Landmark].self, from: data)
                print("Landmarks loaded: \(landmarks)")
            } catch {
                print("Failed to decode landmarks JSON: \(error)")
                print("Received data for landmarks: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            }

            semaphore.signal()
        }.resume()

        semaphore.wait()
        return landmarks
    }

    func load_hikes() -> [Hike] {
        var hikes: [Hike] = []
        let semaphore = DispatchSemaphore(value: 0)

        guard let url = URL(string: "http://127.0.0.1:5000/get_hikes") else {
            print("Invalid URL for hikes")
            return hikes
        }

        print("Fetching hikes...")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch hikes: \(error.localizedDescription)")
                semaphore.signal()
                return
            }

            guard let data = data else {
                print("No data received for hikes")
                semaphore.signal()
                return
            }

            do {
                let decoder = JSONDecoder()
                hikes = try decoder.decode([Hike].self, from: data)
                print("Hikes loaded: \(hikes)")
            } catch {
                print("Failed to decode hikes JSON: \(error)")
                print("Received data for hikes: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            }

            semaphore.signal()
        }.resume()

        semaphore.wait()
        return hikes
    }
}
