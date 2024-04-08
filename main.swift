import Foundation




// --------------------------- S T R U C T -----------------------------------------------
struct Question: Codable {
    let question: String
    let propositions: [String]
    let reponseIndex: Int
    let niveau: String
    let categorie: String
}

struct player: Codable{
    var name: String
    var difficulty : Int
    var score : Int
}


// --------------------------------- P L A Y E R ---------------------------------------
// creer un profil
func createGamer(){

    // enter a name 
    print("Enter your name :")
        guard let name = readLine() else {
        print("Invalid name.")
        return
    }

    // choose a level
    print("Choose your level diffecult :")
    print (" 1: facile ")
    print (" 2: moyen ")
    print (" 3: difficile ")

    guard let choixEntred = readLine(), let difficulty = Int(choixEntred), difficulty <= 3 else {
        print("Difficulté invalide, veuillez réessayer.")
        return
    }

    // creating the gamer
    let player = player(name:name, difficulty:difficulty )


    // player to JSON.
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted 
    guard let jsonData = try? encoder.encode(player) else {
        print("Failed to encode person to JSON.")
        return
    }
    
    
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let filePath = URL(fileURLWithPath: currentPath).appendingPathComponent("player.json")
    
    // save the player in a file JSON
    do {
        try jsonData.write(to: filePath)
        print("Profile saved ")
    } catch {
        print("Failed to write JSON data to file: \(error)")
    }
}

// ---------------------- Q U E S T I O N -----------------------------------------------------
















// ----------------------------------- M A I N -----------------------------------
// creer un joueur
createGamer()