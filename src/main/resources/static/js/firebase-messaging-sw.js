importScripts(
    "https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js"
);

importScripts(
    "https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js"
);


firebase.initializeApp({

    apiKey: "YOUR_API_KEY",

    authDomain: "YOUR_PROJECT.firebaseapp.com",

    projectId: "YOUR_PROJECT_ID",

    storageBucket: "YOUR_PROJECT.appspot.com",

    messagingSenderId: "YOUR_SENDER_ID",

    appId: "YOUR_APP_ID"

});


const messaging = firebase.messaging();


messaging.onBackgroundMessage(function (payload) {

    console.log("Background message:", payload);

    const title = payload.notification.title;

    const options = {
        body: payload.notification.body,
        icon: "logo.jpg"
    };

    self.registration.showNotification(title, options);
});