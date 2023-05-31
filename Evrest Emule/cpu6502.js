class CPU6502 {
    constructor() {
      this.reset();
    }
  
    reset() {
      // Initialiser les registres et la mémoire
    }
  
    fetch() {
      // Lire l'instruction actuelle depuis la mémoire
    }
  
    decode(instruction) {
      // Décoder l'instruction en opération et en paramètres
    }
  
    execute(operation, parameters) {
      // Exécuter l'opération avec les paramètres donnés
    }
  
    tick() {
      // Une "unité de temps" de l'horloge CPU
      const instruction = this.fetch();
      const { operation, parameters } = this.decode(instruction);
      this.execute(operation, parameters);
    }
  }
  