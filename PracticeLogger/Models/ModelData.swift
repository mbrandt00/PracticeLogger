//
//  ModelData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import Foundation

@Observable
class ModelData{
    var pieces: [Piece] = load("pieceData.json")
    
}


func load<T: Decodable>(
    _ filename: String
) -> T {
    let data: Data
    guard let file = Bundle.main.url(
        forResource: filename,
        withExtension: nil
    )
    else{
        fatalError(
            "Couldn't find \(filename) in main bundle"
        )
    }
    do {
        data = try Data(contentsOf: file)
    }catch {
        fatalError("Couldn't load \(filename) from main bundle: \n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch let error {
        fatalError("Couldn't parse, got error:  \(error)")
    }
    
}
