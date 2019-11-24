
//configure http request to check if name exists in the database
function validateName(name)
{
	var xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
		if (this.readyState == 4 && this.status == 200) {

			//the list of names from the http request
			var res = this.responseText;
			//alert(this.responseText);
			//alert(this.getAllResponseHeaders());
			if("true"  == this.responseText)
			{				
				document.getElementById("loader").style.display = "none";
				//alert("true");
				location.href = "/userDisplay?name="+name;
				return true;
			}
			else
			{
				document.getElementById("loader").style.display = "none";	
		    alert("Name is not registered with PD-PAL!")
				return false;
			}
		}
		else	
		{
			//alert("request status not returned yet");
			//alert(this.status);
			//alert(this.readyState);
		}
  };

	//configure http request
  //xhttp.open('POST', 'https://us-central1-pd-pal.cloudfunctions.net/login', true/*asynchronous*/);
	var url = "/login?name=";
	var string= url.concat(name);

  xhttp.open('GET', string, true/*asynchronous*/);
  //xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	//send http request with post data as string
  xhttp.send(string);
}




//check that the name is not empty, and then send a request to verify the name
function validateForm(txt) {
	document.getElementById("loader").style.display = "block";
	//var x = document.forms["loginForm"]["username"].value;
	if (txt == "") {
		alert("Name must be filled out");
		document.getElementById("loader").style.display = "none"
	 return true;
	}

	//check if the name is in the database
	validateName(txt)
}
/*
	// Check browser support
	if (typeof(Storage) !== "undefined") {
		// Store
		localStorage.setItem("lastname", "Smith");
		// Retrieve
		document.getElementById("result").innerHTML = localStorage.getItem("lastname");
	} else {
		document.getElementById("result").innerHTML = "Sorry, your browser does not support Web Storage...";
	}
*/
