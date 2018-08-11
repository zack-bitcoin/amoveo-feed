
(function post() {
    document.body.appendChild(document.createElement("br"));
    var div = document.createElement("div");
    document.body.appendChild(div);

    var button = document.createElement("input");
    button.type = "button";
    button.value = "generate unsigned post request";
    button.onclick = generate_unsigned_request;
    var unsigned_div = document.createElement("div");

    //inputs for all the info in a post
    // text
    //bitcoin_address, veo_to, time_limit, veo_amount, bitcoin_amount
    var text = input_text_maker("text to post", div);
    div.appendChild(document.createElement("br"));
    
    var button2 = document.createElement("input");
    button2.type = "button";
    button2.value = "publish signed trade request";
    button2.onclick = publish_signed_request;
    var signed = document.createElement("input");
    signed.type = "text";
    
    div.appendChild(button);
    div.appendChild(unsigned_div);
    div.appendChild(button2);
    div.appendChild(signed);


    var instructions = document.createElement("div");
    instructions.innerHTML = "To sign, you can use a light node, like the one linked from this page: https://github.com/zack-bitcoin/amoveo";
    div.appendChild(instructions);

    function generate_unsigned_request(){
	variable_public_get(["height"], function(height) {
	    variable_public_get(["pubkey"], function(server_pubkey) {
		var request = [-7, 30, pubkey.value, height, btoa(text.value), server_pubkey];
		unsigned_div.innerHTML = JSON.stringify(request);
	    });
	});
    };
    function publish_signed_request(){
	var sr = JSON.parse(signed.value);
	variable_public_get(["post", sr], function(x) {
	    console.log("publish signed request");
	});
    }
})();
