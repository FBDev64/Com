const audioPlayer = document.getElementById("audio-player");
const playPauseBtn = document.getElementById("play-pause-btn");
const seekSlider = document.getElementById("seek-slider");
const volumeSlider = document.getElementById("volume-slider");
const muteBtn = document.getElementById("mute-btn");
const loadBtn = document.getElementById("load-btn");
const fileInput = document.getElementById("audio-file-input");

let isPlaying = false;

function playPause() {
	if (isPlaying) {
		audioPlayer.pause();
		playPauseBtn.innerHTML = "Play";
	} else {
		audioPlayer.play();
		playPauseBtn.innerHTML = "Pause";
	}
	isPlaying = !isPlaying;
}

function seek() {
	const duration = audioPlayer.duration;
	const currentTime = audioPlayer.currentTime;
	seekSlider.value = (100 * currentTime) / duration;
}

function setVolume() {
	audioPlayer.volume = volumeSlider.value / 100;
	if (audioPlayer.volume === 0) {
		muteBtn.innerHTML = "Unmute";
	} else {
		muteBtn.innerHTML = "Mute";
	}
}

function toggleMute() {
	if (audioPlayer.volume === 0) {
		audioPlayer.volume = volumeSlider.value / 100;
		muteBtn.innerHTML = "Mute";
	} else {
		audioPlayer.volume = 0;
		muteBtn.innerHTML = "Unmute";
	}
}

function loadFile() {
	fileInput.click();
}

function handleFile() {
	const file = fileInput.files[0];
	const url = URL.createObjectURL(file);
	audioPlayer.src = url;
	playPauseBtn.innerHTML = "Play";
	isPlaying = false;
}

playPauseBtn.addEventListener("click", playPause);
audioPlayer.addEventListener("timeupdate", seek);
volumeSlider.addEventListener("input", setVolume);
muteBtn.addEventListener("click", toggleMute);
loadBtn.addEventListener("click", loadFile);
fileInput.addEventListener("change", handleFile);
