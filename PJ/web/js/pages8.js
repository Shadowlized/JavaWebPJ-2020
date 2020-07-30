let pagePicCount = 8;
let picArray = [];
for(let i = 1; i <= 100; i++){
    picArray[i] = document.getElementById("id"+i);
}
for(let i = pagePicCount+1; i <= 100; i++){
    picArray[i].className = "div-favorites off";
}
for(let i = 1; i <= pagePicCount; i++){
    picArray[i].className = "div-favorites on";
}

function funct1() {
    for(let i = 1; i <= pagePicCount; i++){
        picArray[i].className = "div-favorites on";
    }
    for(let i = pagePicCount+1; i <= 100; i++){
        picArray[i].className = "div-favorites off";
    }

}
function funct2() {
    for(let i = 1; i <= pagePicCount; i++){
        picArray[i].className = "div-favorites off";
    }
    for(let i = pagePicCount+1; i <= 2*pagePicCount; i++){
        picArray[i].className = "div-favorites on";
    }
    for(let i = 2*pagePicCount+1; i <= 100; i++){
        picArray[i].className = "div-favorites off";
    }
}
function funct3() {
    for(let i = 1; i <= 2*pagePicCount; i++){
        picArray[i].className = "div-favorites off";
    }
    for(let i = 2*pagePicCount+1; i <= 3*pagePicCount; i++){
        picArray[i].className = "div-favorites on";
    }
    for(let i = 3*pagePicCount+1; i <= 100; i++){
        picArray[i].className = "div-favorites off";
    }
}
function funct4() {
    for(let i = 1; i <= 3*pagePicCount; i++){
        picArray[i].className = "div-favorites off";
    }
    for(let i = 3*pagePicCount+1; i <= 4*pagePicCount; i++){
        picArray[i].className = "div-favorites on";
    }
    for(let i = 4*pagePicCount+1; i <= 100; i++){
        picArray[i].className = "div-favorites off";
    }
}
function funct5() {
    for(let i = 1; i <= 4*pagePicCount; i++){
        picArray[i].className = "div-favorites off";
    }
    for(let i = 4*pagePicCount+1; i <= 5*pagePicCount; i++){
        picArray[i].className = "div-favorites on";
    }
    for(let i = 5*pagePicCount+1; i <= 100; i++){
        picArray[i].className = "div-favorites off";
    }
}
