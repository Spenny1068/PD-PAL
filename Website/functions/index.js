
//which headers or libraries are required
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express')


//path to private_key file:
//var serviceAccount = require("/Users/zjxue/Desktop/pd-pal-firebase-adminsdk-ifk38-8a13678c7e.json");

//Note to self 
//export GOOGLE_APPLICATION_CREDENTIALS="/Users/zjxue/Desktop/pd-pal-firebase-adminsdk-ifk38-8a13678c7e.json"

//initialize the firestore etc
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://pd-pal.firebaseio.com"
});
//class that has access to firestore database
let db = admin.firestore();



//demo function that returns hello world
 exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
 });


//login function, returns "true" if user is in the database
//								returns "false" if user is no in the database
 exports.login = functions.https.onRequest((request, response) => {
		//array to store users
		var users = [];
		let usersRef = db.collection('Users');
		let allUsers = usersRef.get()
			.then(snapshot => {
				snapshot.forEach(doc => {
					users.push(doc.id);
				});
				var req_name = "";
				if(request.method === "POST")
				{
					console.log("POST");
					console.log("request.body.name -> ",request.body.name);
					req_name = request.body.name;
				}
				else if(request.method === "GET") {
					console.log("GET");
					console.log(request.query.name)
					req_name = request.query.name;
				}
				//check if the name is in the realtime database
				if(users.includes(req_name))
				{
					response.send("true");
				}
				else 
				{
					response.send("false");
				}

				//wait until the promise is fufilled then send response
				//response.send(JSON.stringify(users));
				//response.send(JSON.stringify(request.body.name));
				return null;
		})
		.catch(err => {
			console.log('Error getting documents',err);
			response.send(/*JSON.stringify(users)*/"error");
		  //response.send(JSON.stringify(request.body.name));
		})
		//console.log("Request.body->", request.body)
		
  });




//function that returns exercise data in JSON format from a start date to an end data
//input: name // string of the user's name
//input: sDate //string of start date, in format yyyymmddhh
//input: eDate //string of end date, in format   yyyymmddhh
exports.exercise_data = functions.https.onRequest((request, response) => {

	//log our the query params of the request in the google cloud function console
	console.log(request.query.name);
	console.log(request.query.sDate);
	console.log(request.query.eDate); 


	//store query params in into variables
	var name = request.query.name;
	var sDate = request.query.sDate;
	var eDate = request.query.eDate;

	//data structure of the return data
	var returnData = 
	{
		"name" : name,
		exData : 
		[
		]
	}

	//find exercise data in our DB for that user between the specified dates
	let exDataRef = db.collection('Users').doc(name).collection('ExerciseData');
	let allUsers = exDataRef.get()
		.then(snapshot => {
			snapshot.forEach(doc => {
				//compare the data on firebase to see if it's within the correct dates
				//refer to https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_localecompare
				if( (sDate.localeCompare(doc.id) <= 0) && (eDate.localeCompare(doc.id) >= 0) )
				{
					
					var docData = doc.data();
					console.log('Doc Data: ', JSON.stringify(docData));
					day_ex_Data = 
					{
						"date" : doc.id,
						"stepsTaken": docData.StepsTaken,
						"exercises_done": JSON.stringify(docData.ExercisesDone)
					}
					returnData.exData.push(day_ex_Data);
					//console.log('returnData: ', returnData.length());
					//console.log('hi');
				}
			})
			response.send(JSON.stringify(returnData));

			return null;
		})
			//error case where documents are not able to be retrieved
		.catch(err => {
			console.log('Error getting documents',err);
			response.send(/*JSON.stringify(users)*/"error");
			//response.send(JSON.stringify(request.body.name));
		});
	
});

