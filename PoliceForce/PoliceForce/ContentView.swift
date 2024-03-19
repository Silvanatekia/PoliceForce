
import SwiftUI

struct PoliceForce: Codable {
    let id: String
    let name: String
}

struct ContentView: View {
    @State private var forces = [PoliceForce]()

    var body: some View {
        NavigationView {
            List(forces, id: \.id) { force in
                NavigationLink(destination: Text("Details for \(force.name)")) {
                    Text(force.name)
                }
            }
            .navigationTitle("Police Forces")
            .task {
                do {
                    forces = try await fetchData()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }

    func fetchData() async throws -> [PoliceForce] {
        let endpoint = "https://data.police.uk/api/forces"
        guard let url = URL(string: endpoint) else {
            throw PFError.InvalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PFError.InvalidResponse
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([PoliceForce].self, from: data)
        } catch {
            throw PFError.InvalidData
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum PFError: Error {
    case InvalidURL
    case InvalidResponse
    case InvalidData
}
