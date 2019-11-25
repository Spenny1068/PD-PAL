//Nov 24, 2019
//update_graphs.js
//This file contains javascript functions that can update the graphs in /userDisplay 
//depending on the time range that is given


//global variables
//tells update_graphs whether to configure for 7 hours or 7 days
var isSevenHours = true;


function updateHistory()
{
	var Hist = document.getElementById("selIntHist");
	if (Hist.value == "p7hours"){
		//alert("You clicked p7hours. his");
		sendHttpDays(true/*is7Hours*/);
	}
	else if (Hist.value == "p7days")
	{
		//alert("func return" + getExData("William Huong",2019111911,2019111912));
		//alert("test date" + getCurrentDate() );
		//alert("You clicked p7days. his")
		sendHttpDays(false/*is7Hours*/);
	}
}




function updateTrends()
{
	var trends = document.getElementById("selIntTrends");
	if (trends.value == "p7hours"){
		//alert("You clicked p7hours. trends");
		sendHttpDays(true/*is7Hours*/);
	}
	else if (trends.value == "p7days")
	{
		//alert("You clicked p7days. trends")
		sendHttpDays(false/*is7Hours*/);
	}
}


function updateSteps()
{
	var steps = document.getElementById("selIntSteps");
	if (steps.value == "p7hours"){
		//alert("You clicked p7hours. steps");
		sendHttpDays(true/*is7Hours*/);
	}
	else if (steps.value == "p7days")
	{
		//alert("You clicked p7days. steps")
		sendHttpDays(false/*is7Hours*/);
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
			update_graphs(res);
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
		isSevenHours = true;
		prev_date.setHours( prev_date.getHours() - 6); //7 hours, including current hour
	} else {
		isSevenHours = false;
		prev_date.setDate(prev_date.getDate() - 6); //7 days including current day
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


//this function will update all the graphs
//where res is the response from the gcloud function: exercise_data
function update_graphs(res)
{
		

	//code for generating the labels	
	//to hold the labels for the graphs
	var labels = [];

	//generate the labels for the graphs
	if(isSevenHours)
	{
		//if the labels must be generated in hours
		//hi
		var i;
		for(i = 6; i >= 0; i--)
		{
			var prev_date = new Date();
			prev_date.setHours( prev_date.getHours() - i);
			var full_date = convertToString(prev_date);
			labels.push( full_date.charAt(8) + full_date.charAt(9) );
		}
	}
	else
	{
		//if the labels must be generated in days
		var i;
		for(i = 6; i >= 0; i--)
		{
			var prev_date = new Date();
			prev_date.setDate( prev_date.getDate() - i);
			var full_date = convertToString(prev_date);
			
			//char at 4 and 5 is the month, char at 6 and 7 is the date
			labels.push(full_date.charAt(4) +  full_date.charAt(5) + '/' 
											+ full_date.charAt(6) + full_date.charAt(7) );
		}

	}
	//end of code for generating the labels

	alert(JSON.stringify(labels));



	//code to parse through exercise history data
	
	//4 element array for trends section
	var trendsData[0,0,0,0];
	//7 by 4 element array for exercise history section
	var exercise_history_data[][];
	//7 element array for step count section
	var stepCountData[0,0,0,0,0,0,0];

	var sCompare = 0;
	var eCompare = 0;
	var sCompareLabel = 0;
	var eCompareLabel = 0;
	//define comparison substring start and end index 
	//for comparing dates // differend for hours and days
	if(isSevenHours)
	{
		sCompare = 8;
		eCompare = 10;
		sCompareLabel = 0;
		eCompareLabel = 2;
	}
	else
	{
		sCompare = 6;
		eCompare = 8;
		sCompareLabel = 3;
		eCompareLabel = 5;
	}
	var data = JSON.parse(res);
	arrayLength= data.exData.length;
	labelArrLength = labels.length;
	for(var i = 0; i < arrayLength; i++)
	{
		//iterate through each of the labels
		for(var j = 0; j < labelArrLength; j++ )
			if(data.exData[i].date.substring(sCompare,eCompare) == 
					labels[j].substring(sCompareLabel,eCompareLabel) )
			{
				//loop represents exData entry i that is to be put in array entry j
				
				//add step count
				stepCountData[j] += data.exData[i].stepsTaken;	
				
			}
	}

}

//will sort the exercise by category
//input exName: the name of the exercise
//output: Flexibility, Strength, Cardio, Balance
// 0 : flexibility
// 1 : strength
// 2 : cardio
// 3 : balance
function sortByCategory(exName)
{	
	var STRENGTH    = ["WALL PUSH-UP","TRICEP KICKBACKS","LATERAL RAISES","KNEE EXTENSION","HEEL STAND"];
	var CARDIO      = ["WALKING"];
	var FLEXIBILITY = ["SINGLE LEG STANCE","QUAD STRETCH","SHOULDER RAISES","NECK SIDE STRETCH","CHEST STRETCH","ARM RAISES"];
	var BALANCE     = ["SIDE LEG LIFT","KNEE MARCHING","HEEL TO TOE"];

}



//References 
/*
https://stackoverflow.com/questions/43420870/responding-to-onclick-in-a-select-html-element
https://www.w3schools.com/js/js_date_methods.asp

*/
