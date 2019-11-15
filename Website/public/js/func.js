
function validateName(name)
{
	var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
  if (this.readyState == 4 && this.status == 200) {
    if( "true" == this.responseText)
		{
			return true;
		}
		else
		{
			return false;
		}
  }
  };
  xhttp.open("POST", "/login", true);
  xhttp.send("name="+name);
	
}



function validateForm() {
	var x = document.forms["loginForm"]["username"].value;
	if (x == "") {
		alert("Name must be filled out");
	 return false;
	}
	//await validateName(name);
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
