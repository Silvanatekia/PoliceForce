//
//  ContentView.swift
//  PoliceForce
//
//  Created by Silvana Tekia on 12/03/2024.
//

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
                }
                .onAppear {
                    fetchData()
                }
            }

            func fetchData() {
                guard let url = URL(string: "https://data.police.uk/api/forces") else {
                    print("Invalid URL")
                    return
                }

                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode([PoliceForce].self, from: data)
                            DispatchQueue.main.async {
                                self.forces = decodedData
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    } else {
                        print("Invalid Data")
                    }
                }.resume()
            }
        }

#Preview {
    ContentView()
}
