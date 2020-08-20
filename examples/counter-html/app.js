window.__duiShowScreen = function(callBack, data) {
  window.callBack = callBack;
  document.getElementById("text").innerHTML = data.contents;
};

document.getElementById("button-increment").addEventListener("click", function() {
  window.callBack("{\"tag\": \"Increment\"}")();
});

document.getElementById("button-decrement").addEventListener("click", function() {
  window.callBack("{\"tag\": \"Decrement\"}")();
});
