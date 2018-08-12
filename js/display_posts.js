(function display_posts() {
    document.body.appendChild(document.createElement("br"));
    var div = document.createElement("div");
    document.body.appendChild(div);

    var start = input_text_maker("start", div);
    start.value = "0";
    div.appendChild(document.createElement("br"));

    var many = input_text_maker("many", div);
    many.value = "10";
    div.appendChild(document.createElement("br"));

    var button = document.createElement("input");
    button.type = "button";
    button.value = "display posts";
    button.onclick = doit;

    var show_here = document.createElement("div");

    div.appendChild(button);
    div.appendChild(document.createElement("br"));
    div.appendChild(show_here);

    function doit(){
	//working here.
	
    }
})();
