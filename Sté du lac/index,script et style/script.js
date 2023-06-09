var token = 1000;

function tokenEarn(num) {
    token = token + num;
}

function tokenSet(num) {
    token = num;
}

function tokenDisplay() {
    console.log(englobeTokenNum)
}

// tokenNum
tokenNum = "Vous avez : " + token + " tokens."