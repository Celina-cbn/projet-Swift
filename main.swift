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




// ---------------------- Q U E S T I O N -----------------------------------------------------




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



// ------------------------------- A F F I C H E-----------------------------------


// afficher des joueur 

func afficherClassement(){
    print(" ---------------------------------------  ")
    print("           SWIFT QUIZ GAME                ")
    print(" ---------------------------------------  ")
    print("       - - -   CLASSEMENT   - - -         ")
    print(" ---------------------------------------\n")




    print(" ---------------------------------------  ")    
    print("          - - -   FACILE   - - -          ")
    print(" ---------------------------------------  ")




    print(" ---------------------------------------  ")
    print("          - - -   MOYEN   - - -           ")
    print(" ---------------------------------------  ")





    print(" ---------------------------------------  ")    
    print("          - - -   DIFFICILE   - - -       ")
    print(" ---------------------------------------  ")




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