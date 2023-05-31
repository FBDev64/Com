class NESEmulator {
    constructor(screenCanvas) {
      this.screenCanvas = screenCanvas;
      this.screenContext = screenCanvas.getContext("2d");
      this.memory = new Uint8Array(65536);
      this.cpu = new CPU6502();
      this.running = false;
    }
  
    loadRom(romData) {
      // Charger le fichier ROM dans la mémoire
      const dataView = new DataView(romData);
      for (let i = 0; i < dataView.byteLength; i++) {
        this.memory[0x8000 + i] = dataView.getUint8(i);
      }
    }
  
    start() {
      this.running = true;
      requestAnimationFrame(this.run.bind(this));
    }
  
    run() {
      // Boucle principale de l'émulateur NES
      while (this.running) {
        const cycles = this.cpu.execute(this.memory);
        this.drawScreen();
        // Mettre à jour les périphériques
        // Attendre jusqu'au prochain cycle
      }
    }
  
    drawScreen() {
      // Dessiner l'écran
      const imageData = this.screenContext.createImageData(256, 240);
      // Copier les données de l'écran dans imageData.data
      this.screenContext.putImageData(imageData, 0, 0);
    }
  }
  