function update() {
    document.getElementById('text').value = donutcount;
    document.title = donutcount + " Donuts";
    
    document.getElementById('ammountMultiplier').innerHTML = "Multiplier Upgrade x" + (multiplier+1);
    document.getElementById('ammountMultiplier2').innerHTML = "x" + (multiplier+1);
    document.getElementById('costMultiplier').innerHTML = ((multiplier+1) * 100) + " Donuts";
    document.getElementById('currentMultiplier').innerHTML = "Your current Multiplier is x" + (multiplier);
    
    document.getElementById('ammountAutoClick').innerHTML = "You Own " + autoClick + " Auto Clickers";
    document.getElementById('costAutoClick').innerHTML = ((autoClick+1) * 12) + " Donuts";
    
    document.getElementById('ammountBanks').innerHTML = "You Own " + banks + " Banks";
    document.getElementById('costBanks').innerHTML = ((banks+1) * 15) + " Donuts";

    document.getElementById('ammountPrisms').innerHTML = "You Own " + prisms + " Prisms";
    document.getElementById('costPrisms').innerHTML = ((prisms+1) * 150) + " Prisms";
    
    document.getElementById('donutspersecond').innerHTML = "You are gaining " + (((autoClick)+(banks*2)+(prisms))*multiplier) + " Donuts per/s";
}


// Variables
var multiplier = 1;
var donutcount = 0;
var autoClick = 0;
var banks = 0;
var prisms = 0;

var shopName = "DonutEngineer"

function timer() {
    donutcount = donutcount + autoClick*multiplier;
    donutcount = donutcount + banks*2*multiplier;
    donutcount = donutcount + prisms*2*multiplier;
    update()
}
setInterval(timer, 1000)

function save() {
    localStorage.setItem("donutcount", donutcount);
    localStorage.setItem("autoClick", autoClick);
    localStorage.setItem("banks", banks);
    localStorage.setItem("prisms", prisms);
    localStorage.setItem("multiplier", multiplier);
}
function load() {
    donutcount = localStorage.getItem("donutcount");
    donutcount = parseInt(donutcount);

    autoClick = localStorage.getItem("autoClick");
    autoClick = parseInt(autoClick);

    banks = localStorage.getItem("banks");
    banks = parseInt(banks);

    prisms = localStorage.getItem("prisms");
    prisms = parseInt(prisms);

    multiplier = localStorage.getItem("multiplier");
    multiplier = parseInt(multiplier);        
    update()
}
    
function buyAutoClick() {
    if (donutcount >= ((autoClick+1) * 12)) {
        donutcount = donutcount - ((autoClick+1) * 12);
        autoClick = autoClick + 1;
        update()
    }
}
    
function buyBank() {
    if (donutcount >= ((banks+1) * 15)) {
        donutcount = donutcount - ((banks+1) * 15);
        banks = banks + 1;
        update()
    }
}

function buyPrisms() {
    if (donutcount >= ((prisms+1) * 150)) {
        donutcount = donutcount - ((prisms+1) * 150);
        prisms = prisms + 1;
        update()
    }
}

function buyMultiplier() {
    if (donutcount >= ((multiplier+1) * 100)) {
        donutcount = donutcount - ((multiplier+1) * 100);
        multiplier = multiplier + 1;
        update()
    }
}

// add donuts manually
function addDonuts(amount) {
    donutcount = donutcount + amount;
    update()
}

// Permutators

function Consolas() {
  document.getElementById("demo").style.fontFamily = "Consolas";
} function Charcoal() {
    document.getElementById("demo").style.fontFamily = "Charcoal, sans-serif";
}

function Dark() {
    document.body.style.backgroundColor = "#f3f3f3";
    document.body.style.backgroundImage = url('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxASEhUSEhISFRUVFRUVFRUVFRUVEBAQFRUWFhUVFRUYHSggGBolGxUVITEhJSkrLi4uFx8zODMtNygtLisBCgoKBQUFDgUFDisZExkrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIALcBFAMBIgACEQEDEQH/xAAZAAEBAQEBAQAAAAAAAAAAAAACAQADBwT/xAAmEAEBAQEAAQMDBAMBAAAAAAAAARECIRJh8AMxUUFxgdGhsfHB/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/APEVZYDLGWA0jpzykLkF9KzloQJjSLIwFFkGQwOfYC4jdQGxPT7qsgDkLCkW8g51K63kLAc7Ex0xZz7A5Lh3mJIAVLCtGANg3l0xcBwU79MMAaijQS0STAFWYEhYkIGwpEhQFKRIUAliavIFIJamAx8xIcBUpYmgCxaXMBJXSSDOVnIL1HJ16n5T0gEiOnpLACJZ8/DrJ7DgPnrSO/cjl9gHGIaDY59x0o9A4dQcdOgoClJNAUJgGFEiwCixIWAsODIUBsWMoLVGQ5AXkmkWAzFhA5+kpHScrIA+lcdJGvj7A0ns3XH4LkpzQchsde+fGuIL8/ceoQaDWJhWjQc7yOOvlLz8/QHKwe3XHPoHKwcPoKAWJSqWADMwNCgw4CxUhQFhjyWgrRIUgFzHSTwnEdIAyNIRQEXm/wBfwlLnwBz/AE0ieotB0i9357DOkoOt+pzJ+b/hzv1P2gz8oCc/PdrS/wABQS+wadc7cBb1/wBC9MgNIvqHV+ewJ3HK12xy+pAc6Gl1BBKNVKCM1rAkKDCBTgQ4BMhQFjpOR5h6BcnzHPS0C8La5wttoL9yxOYcBrViSLQdZnz9B66c9YDtaeAaAtrW/pqdCC0eoXM+VrPP9f8AnsAYlhWD0CRNUQbquVrt9w7gONoOnUGwHMXTAoJWRgYoMKAUKDCBTgQ4BynHLWB0hBzf5X1AW+G5HqkDpC1zlKdA6ctnkZWgFYlaVoBRs/Vo6T+Ac8/RZ9N358D6gc7P9OfVPryF50HPzWsdLA6AcSmID1BpUOqAUcKjQHEq0dALyxVgc4UCFAKHyEKUDi6OtAKVpWxJQdJS5rmYN6i0JS8gcpwOeadA+Wupe/b7tQa1uaua0gFKc9w+nyd68Ac6CjsTQbGHW0GwKV6c72Cja3qDroFvTn10loWgWoOtAUbCxLAHWS1gc4UGFAKFoFAKFKEIFaNUgHq1OYoLI6c0NLKDp6k0WwHWXwsxzLQdMbmJpc39gLxnz7Db8/CdUJQKNVjAlG+VtG0Bo2rQoJ1R6q0OgS0atogxDKwGHTJ1QCs2sAQoMLmgcZo2gsORzhzsFrRtYDijC0F0tFtAigxdB05iyhKwOvLObSAdUYU5ApRtaRKCWjVodUEoL1RtBrRtWgCVqtGgyajAujVHQSsmsAlBhQClW0VgE0RdBYUoxYBrAWUClaUdWUHTmrOnP1LKDrKoTptA2mpP3aAcIYugso1MGgujsHrobQK0bR1tBUo6loLaNqICpayUGtGqNBNVGBNVIoFKujKugUqjFAjjnq89A6IsqgOLGxtAqsGUpQXFiJoOkrcha0oO2wb054QL6h6qoA6N6WhQbUZAbUbWoIjVLQa1kQGqNqUGVGBIrMCxWYFjMwLqyswHz0fPTMC6NZgXFZgLWZgSxeeWYHSYNqsCSprMAdULVYE1LVYBo6zAlSswIisAozAzMwP/2Q==');
}function White() {
    document.body.style.backgroundColor = "#f3f3f3";
    document.body.style.backgroundImage = url('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUSEhIVFRUXFxoaFxcVGBcYFxoXGhcWGB0YGhoaHSggHRonHxUVIjMiJSkrLi4uFx8zODMtNygtLisBCgoKBQUFDgUFDisZExkrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIALcBEwMBIgACEQEDEQH/xAAXAAEBAQEAAAAAAAAAAAAAAAAAAQIH/8QAJhABAQADAAEDBAMBAQEAAAAA8AABIWERccHRQVGBsTGh8eGRAv/EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwDsUG4NVGoB82R62h3NBuANQdxQ+ajUAbmJ4H1xUdgmaHP1UbmR9oA7iDdBqo7iAOZmMDExBv0gZg7BzEzgYgDcHMwdg36wBquMH6mIOYgzkcqNwaofEFHMwag3MD7ZgDVcw5/kGoIdg5mZwPrQbgo1B2DmYNQBuZf9qNUHcwPI+mYNTwM0we/4gvnv9+P6lcfn+veQD5pgffNcQbgg3BuDcHMQBzEwOzI8UwPMGj4oN1pAkHKjUEzgYmH/ABqZmIKN+lBzFc0GoA1Uag1QdgeB9ZimT3rjMFHMUGq5Hig1AGoNwbg3BLR82Rq0dgDUHcwdoNwBuZHmDczk/cDA81GqYPasEg3BuDcAbmcD6VHMUO894JnOGPP9yeG/asCuB5oNSAOTI8V8n7pgdgngfWo3BqDsAbrQbmB5go1TI+8yOwa9IA3IO4g3AxUapIA7Buf/AFB3EAczIN+sHIGMjFfAz/NK4+xz2gg3Qcg9KjcAag1BzMGoKd/dBuDVTrEEyPtiH29oNwczAGoNwag1BRyDmKDf8zL/AJ9/518wM5GJMD7Zg1BM5ec4/Ur5ecY/qQBqDUHMwagp3/aDcHYNwBzMGoOQczAHa+B9ZjAxIA3Q+YNwcxAGoO4g5Br0gDdZjB+qDcCDUHINQB3EG4NQdgDlTkG6QJUaoOwBuDmYOwbgYqNTJ70GoB8QbkgDmYNQbrg9/wAQTwPtMjxUaoOwQbqOZg3QbguH8e9aeHjz/cgtB2YHmDcAbg5iDmINQBqYOw+JjAzBc0G5gfaDmIA5iDUGoO5gDuZ/8n1oN1HMwBuDmKjVBqANQdzB3MG4A3V/yyd/yuMjECDVaDsAdzBuDcye/wCIGT3rk96DUHYA1KjtBuANwcxBzEzkYgYfFRqg7Ubgg7Buo3QcxAHMTOBiDVB2Cb+3nu/aVz+P/c+0go7iYyfX9wa9IO4go1TMw+aQBqo7iQagDdcZP3Qdg3AHaHP9tZfD80gDsG4NQdxAwPtmtBuYPf8AGYA3DrEy+X6g1AG4OZg7BuBjIxUboOZriCDkhz9QbgDmYNQbg5mAfFcj7YoNVHpBM5PrBzM8H6+sG4A1B2DmYNQWg1B3E/8Ar/X1gD1g1BuDmYHl58f1Jh/HvWCDmYNSo7mAO0G4NyANyZkAaqd/2HaDcAb9IOQcxBqANQag9ZiAO1G4c5QcxAHMQag1BqANQdxJ4P1APv71M+/4mcn7oNQBqDUHYNwBuDcOVgmB9oNVGvWg7AHYNwbg9IA3BzMG6wBqg7mDuajcGRuo3BymYL4eMZk8PGc/3iQWg3B2sEHJINQBqYyM0Of7Ubgo3QcxMZGajUEGoNQakCYf9oN/So3AyPtiDUxk/f0qNfzBBqDcG5nIzAzmuKQczAGqjsGqDcAbg3BuHf8AIHkYrSDUAdzBuo3SBJBqBjJ+qjtBqHx9YKNwcmR9qQINQaoPP1gnjv7lrz3+84/UgDUHZBqC2TlR2DcAag1BzMGoA3MZg1B2BmlrI80Pn8QINwag7AG5jJ9GYNzGD+feBmlcwagDcG4OwbgDlaDdcD7QZ81wPMGoO4gQcg3IA1XI5QcqNQZPj3qOQ+INwINQcg1AwOR/jUwPEy/61/MAesGqDdRyB5ecY/qTw8Y95Ag1DsG4A3BuDdRzEEh8/jMGpAxgYqc5BukCDkHKjUEHMwag9ZiBjD2rKQIPWo1QdzAGvSDsG64gDcGoNQagg1IOwbgDuINw+awD5pKjcEG/5g7io3QcxAG5gfaVyff/AGANUG4NwbgZg3BzEzgYgeHjz/cpnOOfnz7SDQ3QblTvtAHMQag1QdgZH3mD6+9KjuIKOUHMQbqNesAaoO5g7mZyfT9wMjzMD7QekG4LQamMn7qPWCDuYNwbg9IB8/iuB4oNwczBRqg7U5MjzBBuDmIfP4xQ+IA1aHaDmYNQUboN1oOYgDmJkeINetB6wXA+9fAzQakAbg5ip8/+UGoA1JBqCP5z7Svnv94x/UgPh9JJBc5envQbkgPiDUkAekfL6yQMv2+8xJAGpJAfL6x7v7rII/8AaDVZAmXu+skAetcPz7SQZez7VfMkAbg9ZIGHtPL+qyDL/wAqNyQB6x8PpJAxmZc8VkEG4PWSC4/P48e8kg//2Q==');
} 

var x = document.getElementById("myAudio"); 

function playOST() { 
  x.play(); 
} function pauseOST() { 
  x.pause(); 
}