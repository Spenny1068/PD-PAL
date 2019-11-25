//Nov 24, 2019
//update_graphs.js
//This file contains javascript functions that can update the graphs in /userDisplay 
//depending on the time range that is given

function updateHistory()
{
	var Hist = document.getElementById("selIntHist");
	if (Hist.value == "p7hours"){
		//alert("You clicked p7hours. his");
	}
	else if (Hist.value == "p7days")
	{
		//alert("func return" + getExData("William Huong",2019111911,2019111912));
		//alert("test date" + getCurrentDate() );
		//alert("You clicked p7days. his")
	}
}




function updateTrends()
{
	var trends = document.getElementById("selIntTrends");
	if (trends.value == "p7hours"){
		//alert("You clicked p7hours. trends");
	}
	else if (trends.value == "p7days")
	{
		//alert("You clicked p7days. trends")
	}
}


function updateSteps()
{
	var steps = document.getElementById("selIntSteps");
	if (steps.value == "p7hours"){
		//alert("You clicked p7hours. steps");
	}
	else if (steps.value == "p7days")
	{
		//alert("You clicked p7days. steps")
	}

}



//configure http request to check get exercise data from the database
function getExData(name,sDate,eDate)
{
	var xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
		if (this.readyState == 4 && this.status == 200) {

			//the list of names from the http request
			var res = this.responseText;
			alert(res);
			return res;
				//document.getElementById("loader").style.display = "none";
				//document.getElementById("loader").style.display = "none";	
		}
		else	
		{
			//alert("request status not returned yet");
			//alert(this.status);
			//alert(this.readyState);
		}
  };

	//replace spaces with + in http query parameters
	mod_name = name.replace(' ','+');

	//configure http request
	var url = "/exercise_data?name="+mod_name+"&sDate="+sDate+"&eDate="+eDate;
	alert(url);

  xhttp.open('GET', url, true/*asynchronous*/);
  //xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	//send http request with post data as string
  xhttp.send(url);
}

//function that formats the start & end date and name to be sent off as http request
//if is7Hours is true, interval will be 7 hours ago
//if is7Hours is false, interval will be 7 days ago
function sendHttpDays(is7Hours)
{
	var curr_date = new Date();
	var eDate = convertToString(curr_date);

	var prev_date = new Date();
	if(is7Hours){
		prev_date.setHours( prev_date.getHours() - 7);
	} else {
		prev_date.setDate(prev_date.getDate() - 7);
	}	
	
	var sDate = convertToString(prev_date);

	var urlParams = new URLSearchParams(window.location.search);
	var name = urlParams.get('name');

	//send the HTTP request
	
	getExData(name,sDate,eDate);

}




//function that returns the input date in the form yyyymmddhh (string)
//input must be in form of : var date = new Date();
function convertToString(date)
{
	//gets the year as a four digit number
	var year = date.getFullYear();
	var strYear = year.toString();

	//gets month as two digit number, from 0 - 11; so we add one
	var month = date.getMonth() + 1;
	var tempStrMonth =  month.toString();
	var strMonth = '';
	//if the month is one digit, add a zero to the front
	if(tempStrMonth.length == 1){
		strMonth = '0' + tempStrMonth;
	}
	else{
		strMonth = tempStrMonth;
	}

	//gets the date as a two digit number, 1 - 31
	var curr_date = date.getDate();
	var tempStrDay = curr_date.toString();
	var strDate = '';
	//if the date is one digit, add a zero to the front
	if(tempStrDay.length == 1){
		strDate = '0' + tempStrDay;
	}
	else{
		strDate = tempStrDay;
	}

	//gets the hour as a two digit number, 0-23
	var hour = date.getHours();
	var tempStrHour = hour.toString();
	var strHour = '';
	//if the hour is one digit, add a zero to the front
	if(tempStrHour.length == 1){
		strHour = '0' + tempStrHour;
	}
	else{
		strHour = tempStrHour;
	}

	//return in format yyyymmddhh
	return strYear + strMonth + strDate + strHour;
}



//References 
/*
https://stackoverflow.com/questions/43420870/responding-to-onclick-in-a-select-html-element
https://www.w3schools.com/js/js_date_methods.asp

*/
