const functions = require('firebase-functions');
const admin = require('firebase-admin');

//path to private_key file:
var serviceAccount = require("/Users/zjxue/Desktop/pd-pal-firebase-adminsdk-ifk38-8a13678c7e.json");


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://pd-pal.firebaseio.com"
});

let db = admin.firestore();




 // Create and Deploy Your First Cloud Functions
 // https://firebase.google.com/docs/functions/write-firebase-functions

 exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
 });


 exports.login = functions.https.onRequest((request, response) => {

		let usersRef = db.collection('Users');
		let allUsers = usersRef.get()
			.then(snapshot => {
				snapshot.forEach(doc => {
					console.log(doc.id, '=>', doc.data());
				});
		})
		.catch(err => {
			console.log('Error getting documents',err);
		})

  response.send("Login function");
 });
