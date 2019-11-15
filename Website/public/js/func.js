// Your web app's Firebase configuration
var firebaseConfig = {
	apiKey: "AIzaSyCxhb3EdUC1tBUqr5ZVNnZ7u9j2peJzS3c",
	authDomain: "pd-pal.firebaseapp.com",
	databaseURL: "https://pd-pal.firebaseio.com",
	projectId: "pd-pal",
	storageBucket: "pd-pal.appspot.com",
	messagingSenderId: "403272540552",
	appId: "1:403272540552:web:8cf05e88b69c709b221a3d",
	measurementId: "G-E6N8QJ5P8Q"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();

var db = firebase.firestore();


function validateForm() {
	var x = document.forms["loginForm"]["username"].value;
	if (x == "") {
		alert("Name must be filled out");
	 return false;
	}
  db.collection("Users").get().then((querySnapshot) => {
    querySnapshot.forEach((doc) => {
        console.log(`${doc.id} => ${doc.data()}`);
    });
});



	// Check browser support
	if (typeof(Storage) !== "undefined") {
		// Store
		localStorage.setItem("lastname", "Smith");
		// Retrieve
		document.getElementById("result").innerHTML = localStorage.getItem("lastname");
	} else {
		document.getElementById("result").innerHTML = "Sorry, your browser does not support Web Storage...";
	}

}

