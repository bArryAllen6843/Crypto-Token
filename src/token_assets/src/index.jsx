import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { AuthClient } from "@dfinity/auth-client";

const init = async () => { 
  
  const authClient = await AuthClient.create();

  if (await authClient.isAuthenticated()) {
    handleAuthenticated(authClient);
  } else {
    await authClient.login({
      // it will create frontend for login purposes
      identityProvider: "https://identity.ic0.app/#authorize",
      // My identity anchor is 2195647
      onSuccess: () => {
        handleAuthenticated(authClient);
      }
    });
  }
}

async function handleAuthenticated(authClient) {
  ReactDOM.render(<App />, document.getElementById("root"));
}

init();


