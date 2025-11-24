//
//  ExerciseService.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import Foundation

class ExerciseService {
    
    private let apiUrl = "https://4564a526-da72-418d-8518-8c7a56c6e82e.mock.pstmn.io/obtener_ejercicios"
    
    func getFitnessData() async throws -> FitnessResponse {
        guard let url = URL(string: apiUrl) else {
            throw NetworkError.invalidURL
        }
        
        if !ConnectivityService.shared.isConnected {
             throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sin conexión a internet"])
        }        
        return try await NetworkManager.shared.fetch(url: url)
    }
}
