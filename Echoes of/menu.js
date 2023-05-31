document.getElementById("command-input").addEventListener("keydown", function(event) {
    if (event.key === "Enter") {
        var command = event.target.value;
        // Appeler une fonction pour traiter la commande ici
        processCommand(command);
        event.target.value = ""; // Effacer le contenu de l'entrée de commande après traitement
    }
});

function processCommand(command) {
    if (command === "/settingsView") {
        var parameter = prompt("Choisissez un paramètre : Langue, Musique");
        if (parameter === "Langue") {
            var language = prompt("Choisissez la langue : Anglais, Français");
            if (language === "Anglais") {
                var message = "La langue du jeu est maintenant en Anglais";
                alert(decodeURIComponent(escape(message)));
                console.log(message);
            } else if (language === "Français") {
                var message = "La langue du jeu est maintenant en Français";
                alert(decodeURIComponent(escape(message)));
                console.log(message);
            } else {
                alert("Choix invalide");
                console.log("Choix invalide");
            }
        } else if (parameter === "Musique") {
            var message = "Affichage des sources des musiques de jeux";
            alert(message);
            console.log(message);
        } else {
            alert("Choix invalide");
            console.log("Choix invalide");
        }
    } else if (command === "/start") {
        var character = prompt("Choisissez un personnage : Serenity ou Psychology");
        if (character === "Serenity") {
            var message = "Vous avez commencé avec Serenity";
            alert(message);
            console.log(message);
        } else {
            alert("Choix invalide");
            console.log("Choix invalide");
        }
    } else {
        var message = "... Are you braindead ?";
        alert(message);
        console.log(message);
    }

    var commandInput = document.getElementById("command-input");
    var highlightedCommand = command;

    if (command.includes("Serenity")) {
        highlightedCommand = command.replace("Serenity", "<span class='highlight-green'>Serenity</span>");
    }

    if (command.includes("Psychology")) {
        highlightedCommand = highlightedCommand.replace("Psychology", "<span class='highlight-purple'>Psychology</span>");
    }

    commandInput.value = highlightedCommand;
    commandInput.classList.add("highlight-command");
} 

// easter egg 1
var easterEgg1 = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";


// Easter egg 3 : note, il n'y a pas de 2
function demo() {
    console.log("Attendez un peu.");
}

// Highlighting
function highlightWord(element, searchFor, classWrapper){

    // Gets the text from within the selected element
    // Could also be written as $(element).text() for text only
    // Define blank array for word variations (uppercase, lowercase ect)
    
    var textString = $(element).html(),
        wordArray = [];
    
    // Add the search word as it's written
    wordArray.push(searchFor);
    // Add the search word with a capital letter
    wordArray.push(searchFor.substr(0,1).toUpperCase() + searchFor.substr(1, searchFor.length - 1));
    // Add a fully uppercase version
    wordArray.push(searchFor.toUpperCase());
    // Add a fully lowercase version
    wordArray.push(searchFor.toLowerCase());
    
    
    // Loop through all the searchFor variations
    for (var i = 0; i < wordArray.length; i++) {
    
    // If text within the string equals a search word, add a span element around it
    // Update the text string for the next sequence in the loop
    if (textString.indexOf(wordArray[i]) >= 0){ 
    var findAll = new RegExp(wordArray[i], 'g');
    textString = textString.replace(findAll, '<span class="' + classWrapper + '">' + wordArray[i] + '</span>');
    }
    
    }
    
    // Replace the original string with the new highlighted version
    $(element).html(textString);
    
    }

    highlightWord('.image-container', 'Serenity', 'Psychology');

