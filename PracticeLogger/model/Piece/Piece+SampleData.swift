////
////  Piece+SampleData.swift
////  PracticeLogger
////
////  Created by Michael Brandt on 8/13/24.
////
//
// import Foundation
//
// extension Piece {
//    func randomMovement() -> Movement? {
//        return movements.randomElement()
//    }
//
//    static let example1 = Piece(
//        workName: "Sonata 2 in B flat Minor Funeral March",
//        composer: Composer(name: "Frederic Chopin"),
//        movements: [
//            Movement(name: "Grave - Doppio movimento", number: 1),
//            Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
//            Movement(name: "Marche Funebre", number: 3),
//            Movement(name: "Finale", number: 4)
//        ],
//        formattedKeySignature: "Bb Minor",
//        catalogue_type: .Op,
//        catalogue_number: 35,
//        nickname: "Funeral March",
//        tonality: .minor,
//        key_signature: .bFlat
//    )
//
//    static let example2 = Piece(
//        workName: "Symphony No. 5",
//        composer: Composer(name: "Ludwig van Beethoven"),
//        movements: [
//            Movement(name: "Allegro con brio", number: 1),
//            Movement(name: "Andante con moto", number: 2),
//            Movement(name: "Scherzo", number: 3),
//            Movement(name: "Allegro", number: 4)
//        ],
//        formattedKeySignature: "C Minor",
//        catalogue_type: .Op,
//        catalogue_number: 67,
//        nickname: "Fate Symphony",
//        tonality: .minor,
//        key_signature: .c
//    )
//
//    static let example3 = Piece(
//        workName: "Piano Concerto No. 21",
//        composer: Composer(name: "Wolfgang Amadeus Mozart"),
//        movements: [
//            Movement(name: "Allegro", number: 1),
//            Movement(name: "Andante", number: 2),
//            Movement(name: "Allegro vivace", number: 3)
//        ],
//        formattedKeySignature: "C Major",
//        catalogue_type: .K,
//        catalogue_number: 467,
//        nickname: "Elvira Madigan",
//        tonality: .major,
//        key_signature: .c
//    )
//
//    static let example4 = Piece(
//        workName: "The Four Seasons - Winter",
//        composer: Composer(name: "Antonio Vivaldi"),
//        movements: [
//            Movement(name: "Allegro non molto", number: 1),
//            Movement(name: "Largo", number: 2),
//            Movement(name: "Allegro", number: 3)
//        ],
//        formattedKeySignature: "F Minor",
//        catalogue_type: .Op,
//        catalogue_number: 297,
//        nickname: "Winter",
//        tonality: .minor,
//        key_signature: .f
//    )
//
//    static let example5 = Piece(
//        workName: "Clair de Lune",
//        composer: Composer(name: "Claude Debussy"),
//        movements: [
//            Movement(name: "Clair de Lune", number: 1)
//        ],
//        formattedKeySignature: "D Flat Major",
//        catalogue_type: .Op,
//        catalogue_number: 46,
//        nickname: "Moonlight",
//        tonality: .major,
//        key_signature: .dFlat
//    )
//
//    static let example6 = Piece(
//        workName: "Boléro",
//        composer: Composer(name: "Maurice Ravel"),
//        movements: [
//            Movement(name: "Boléro", number: 1)
//        ],
//        formattedKeySignature: "C Major",
//        catalogue_type: .Op,
//        catalogue_number: 71,
//        nickname: "Boléro",
//        tonality: .major,
//        key_signature: .c
//    )
//
//    static let example7 = Piece(
//        workName: "Symphony No. 9 - Ode to Joy",
//        composer: Composer(name: "Ludwig van Beethoven"),
//        movements: [
//            Movement(name: "Allegro", number: 1),
//            Movement(name: "Molto vivace", number: 2),
//            Movement(name: "Adagio", number: 3),
//            Movement(name: "Allegro", number: 4)
//        ],
//        formattedKeySignature: "D Minor",
//        catalogue_type: .Op,
//        catalogue_number: 125,
//        nickname: "Ode to Joy",
//        tonality: .minor,
//        key_signature: .d
//    )
//
//    static let example8 = Piece(
//        workName: "Gymnopédies No. 1",
//        composer: Composer(name: "Erik Satie"),
//        movements: [
//            Movement(name: "Lent et douloureux", number: 1)
//        ],
//        formattedKeySignature: "D Major",
//        catalogue_type: .Op,
//        catalogue_number: 3,
//        nickname: "Gymnopédies",
//        tonality: .major,
//        key_signature: .d
//    )
//
//    static let example9 = Piece(
//        workName: "Concerto for Two Violins",
//        composer: Composer(name: "Johann Sebastian Bach"),
//        movements: [
//            Movement(name: "Allegro", number: 1),
//            Movement(name: "Largo", number: 2),
//            Movement(name: "Allegro", number: 3)
//        ],
//        formattedKeySignature: "D Minor",
//        catalogue_type: .BWV,
//        catalogue_number: 1043,
//        nickname: "Double Violin Concerto",
//        tonality: .minor,
//        key_signature: .d
//    )
//
//    static let example10 = Piece(
//        workName: "Adagio for Strings",
//        composer: Composer(name: "Samuel Barber"),
//        movements: [
//            Movement(name: "Adagio", number: 1)
//        ],
//        formattedKeySignature: "A Minor",
//        catalogue_type: .Op,
//        catalogue_number: 11,
//        nickname: "Adagio",
//        tonality: .minor,
//        key_signature: .a
//    )
//
//    static let examplePieces: [Piece] = [example1, example2, example3, example4, example5, example6, example7, example8, example9, example10]
// }
