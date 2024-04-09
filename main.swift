// importation nécessaire
import Foundation


// --------------------------- S T R U C T -----------------------------------------------



// structure pour les question
struct Question: Codable {
    let question: String
    let propositions: [String]
    let reponse: Int
    let niveau: Int
    let categorie: String
}


// structure du gamer
struct Player: Codable{
    var name: String
    var difficulty : Int
    var score : Int
}


// --------------------------------- P L A Y E R ---------------------------------------


// creer un gamer
func createGamer() -> Player{

    // enter a name 
    print("Enter your name :")
        guard let name = readLine() else {
        print("Invalid name.")
        exit(0)
    }

    // choose a level
    print("Choose your level diffecult :")
    print (" 1: facile ")
    print (" 2: moyen ")
    print (" 3: difficile ")

    var choice: Int=0
    while choice != 1 && choice != 2 && choice != 3{
        guard let choixEntred = readLine(), let difficulty = Int(choixEntred) else {
            print("Choisissez un chiffre valide svp")
            continue
        }
                    
        choice = difficulty

            if choice != 1 && choice != 2 && choice != 3 {
                print("Please enter 1 , 2 or 3")
            }
    }

    // creating the gamer
    return Player(name:name, difficulty:choice, score: 0 )
}




// ---------------------------- S A V E  P L A Y E R ----------------------------------


// enregistrement du gamer dans le JON
func savePlayerInJson(player: Player) {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let filePath = URL(fileURLWithPath: currentPath).appendingPathComponent("player.json")

    var existingPlayers: [Player] = []

    if let existingData = try? Data(contentsOf: filePath),
       let decodedPlayers = try? JSONDecoder().decode([Player].self, from: existingData) {
        existingPlayers = decodedPlayers
    }

    existingPlayers.append(player)

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    guard let combinedData = try? encoder.encode(existingPlayers) else {
        print("Failed to encode combined player data.")
        return
    }

    do {
        try combinedData.write(to: filePath)
    } catch {
        print("Failed to write player data to file:", error)
    }
}




// ------------------------- Q U E S T I O N -----------------------------------------------------




func getQuestions(forLevel level: Int, fromJSON json: Data) -> [(question: String, propositions: [String], reponse: Int)] {

    var questionsAndPropositions: [(question: String, propositions: [String], reponse: Int)] = []
    do {
        let questions = try JSONDecoder().decode([Question].self, from: json)
        for question in questions {
            if question.niveau == level {
                questionsAndPropositions.append((question.question, question.propositions, question.reponse))
            }
        }
    } catch {
        print("Erreur lors du décodage du JSON :", error)
    }
    return questionsAndPropositions
}



// -------------------------- print questions ---------------------------------


// Fonction pour afficher les questions, obtenir les réponses du joueur et mettre à jour le score
func writeQuestions(player: inout Player, questions: [(question: String, propositions: [String], reponse: Int)]) {

    for (question, propositions, reponse) in questions {
        print("")
        print("Question: \(question)")
        print("Propositions: \(propositions)")
        print("What is your answer:")

        var choice : Int=0
        while choice != 1 && choice != 2 && choice != 3 {
            guard let choiceResponse = readLine(), let choix = Int(choiceResponse) else {
                print("Choisissez un chiffre valide svp")
                continue
            }


            choice = choix
            if choice != 1 && choice != 2 && choice != 3 {
                print("Please enter 1 , 2 or 3")
            }
        }

            if choice == reponse {
                print("Bonne réponse !!")
                player.score += 1
            }
            else{
                print("Mauvaise réponse :( ")
            }
        
        print("-------------------------------------------------------------------")
    }
}



// ------------------------G E T  P L A Y E R S------------------------------------------


func getPlayer(forLevel level: Int, fromJSON json: Data) -> [(name: String, score: Int)] {

    var players: [(name: String, score: Int)] = []
    do {
        let OnePlayers = try JSONDecoder().decode([Player].self, from: json)
        for player in OnePlayers {
            if player.difficulty == level {
                players.append((player.name, player.score))
            }
        }
    } catch {
        print("Erreur lors du décodage du JSON :", error)
    }
    return players
}

//-------------------- A F F I C H E R   P L A Y E R S --------------------------------
            
            
func printPlayer(players myPlayers:[(name :String, score:Int)]){

        for (name, score) in myPlayers {
            print(" \(name)  \(score) ")
        }
}

//----------------------------- T R I E R  -----------------------------------------------

func playerDescending(_ players: [(name: String, score: Int)]) -> [(name: String, score: Int)] {
    return players.sorted(by: { $0.score > $1.score })
}


// ---------------------- A F F I C H E R    S C O R E S -----------------------------------


// afficher des joueur 

func afficherClassement(){
    print(" ---------------------------------------  ")
    print("           SWIFT QUIZ GAME                ")
    print(" ---------------------------------------  ")
    print("       - - -   CLASSEMENT   - - -         ")
    print(" -----------------------------------------")




        var jsonData: Data

        // Charger les données JSON depuis le fichier "questions.json"
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let filePath = URL(fileURLWithPath: currentPath).appendingPathComponent("player.json")

    do {
        // Affichage pour le niveau facile
        jsonData = try Data(contentsOf: filePath)
        let myPlayersFacile = getPlayer(forLevel: 1, fromJSON: jsonData)
        let sortedPlayerFacile = playerDescending(myPlayersFacile)
        print(" ---------------------------------------  ")
        print("          - - -   FACILE   - - -          ")
        print(" ---------------------------------------  ")
        printPlayer(players: sortedPlayerFacile)
    } catch {
        print("Error loading JSON file:", error)
        return
    }

    do {
        // Affichage pour le niveau moyen
        jsonData = try Data(contentsOf: filePath)
        let myPlayersMoyen = getPlayer(forLevel: 2, fromJSON: jsonData)
        let sortedPlayerMoyen = playerDescending(myPlayersMoyen)
        print(" ---------------------------------------  ")
        print("          - - -   MOYEN   - - -           ")
        print(" ---------------------------------------  ")
        printPlayer(players: sortedPlayerMoyen)
    } catch {
        print("Error loading JSON file:", error)
        return
    }

    do {
        // Affichage pour le niveau difficile
        jsonData = try Data(contentsOf: filePath)
        let myPlayersDifficile = getPlayer(forLevel: 3, fromJSON: jsonData)
        let sortedPlayerDifficile = playerDescending(myPlayersDifficile)
        print(" ---------------------------------------  ")
        print("          - - -   DIFFICILE   - - -       ")
        print(" ---------------------------------------  ")
        printPlayer(players: sortedPlayerDifficile)
    } catch {
        print("Error loading JSON file:", error)
        return
    }

}


// ----------------------------------- M A I N ----------------------------------------------

func main() {
    print(" ---------------------------------------  ")
    print("           SWIFT QUIZ GAME                ")
    print(" ---------------------------------------  ")
    print("       - - -   New Player   - - -         ")
    print(" ---------------------------------------  ")


//creation d'un player
    var player = createGamer()
    var loop = true


//boucle pour rejouer
    while loop {
        let jsonData: Data

        // Charger les données JSON depuis le fichier "questions.json"
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let filePath = URL(fileURLWithPath: currentPath).appendingPathComponent("questions.json")

        do {
        //print des question
            jsonData = try Data(contentsOf: filePath)
            let questions = getQuestions(forLevel: player.difficulty, fromJSON: jsonData)
            writeQuestions(player: &player, questions: questions)
        } catch {
            print("Error loading JSON file:", error)
            return
        }
/*
 facile  -- >  1 point par bonne reponse
 moyen   -- >  2
 difficile   -- >  3
*/
        if player.difficulty==2 {
            player.score*=2
        }
        if player.difficulty==3 {
            player.score*=3
        }

        //savePlayerInJson(player: player)
        print("Votre score est de : \(player.score) \n")
        print("\n Réesseyer? \n 1- OUI \n 2 - NON")

        var choice = 0
        while choice != 1 && choice != 2 {
            guard let choiceEntered = readLine(), let intChoice = Int(choiceEntered) else {
                print("Invalid choice. Please enter 1 for YES or 2 for NO.")
                continue
            }

            choice = intChoice

            if choice != 1 && choice != 2 {
                print("Please enter 1 for OUI or 2 for NON.")
            }
        }

        if choice == 2 {
            loop = false
            savePlayerInJson(player: player)
        }

        player.score=0

    }// reboucler
   


    print("-----------------C H O O S E -----------------------")
    print(" 1 -- new player \n 2 -- Classement ")
    var choice=0
    while choice != 1 && choice != 2{
        guard let choixEntred = readLine(), let intChoice = Int(choixEntred) else {
            print("Choisissez un chiffre valide svp")
            continue
        }
                    
        choice = intChoice

            if choice != 1 && choice != 2 && choice != 3 {
                print("Please enter 1 , 2 or 3")
            }
    }

    if(choice == 1){
        main()
    }
    else{
        afficherClassement()
    }
}






// ------------------------------- L A N C E M E N T  D U  J E U ----------------------------------------------

// Appel de la fonction principale
main()





