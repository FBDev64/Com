document.getElementById("backpack").onclick = function() {
    document.getElementById("books").style.display = "block";
  };
  
  document.getElementById("books ul li a").onclick = function() {
    var text = this.innerHTML;
    alert(text);
  };
  