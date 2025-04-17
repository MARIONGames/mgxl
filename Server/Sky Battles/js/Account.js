const titleId = "YOUR_PLAYFAB_TITLE_ID";
PlayFab.settings.titleId = titleId;

const userSessionTicket = localStorage.getItem("playfab_session_ticket");
PlayFab.settings.sessionTicket = userSessionTicket;

function showMessage(message) {
  document.getElementById("statusMessage").innerText = message;
}

function updateDisplayName() {
  const name = document.getElementById("displayNameInput").value;

  PlayFabClientSDK.UpdateUserTitleDisplayName({
    DisplayName: name
  }, function(result) {
    showMessage("Display name updated!");
  }, function(error) {
    showMessage("Error: " + error.errorMessage);
  });
}

function sendEmailChange() {
  const email = document.getElementById("emailInput").value;

  PlayFabClientSDK.AddOrUpdateContactEmail({
    EmailAddress: email
  }, function(result) {
    showMessage("A confirmation email has been sent.");
  }, function(error) {
    showMessage("Error: " + error.errorMessage);
  });
}

function sendPasswordReset() {
  const email = document.getElementById("emailInput").value;

  PlayFabClientSDK.SendAccountRecoveryEmail({
    Email: email,
    TitleId: titleId
  }, function(result) {
    showMessage("Password reset email sent.");
  }, function(error) {
    showMessage("Error: " + error.errorMessage);
  });
}

function saveLanguage() {
  const language = document.getElementById("languageSelect").value;

  PlayFabClientSDK.UpdateUserData({
    Data: {
      Language: language
    }
  }, function() {
    showMessage("Language saved.");
  }, function(error) {
    showMessage("Error saving language: " + error.errorMessage);
  });
}

function enableTwoStep() {
  PlayFabClientSDK.ExecuteCloudScript({
    FunctionName: "EnableTwoStep",
    FunctionParameter: {
      email: ""
    },
    GeneratePlayStreamEvent: true
  }, function(result) {
    showMessage("2FA enabled, check your email.");
  }, function(error) {
    showMessage("Error enabling 2FA: " + error.errorMessage);
  });
}

function disableTwoStep() {
  PlayFabClientSDK.ExecuteCloudScript({
    FunctionName: "DisableTwoStep"
  }, function(result) {
    showMessage("2FA disabled.");
  }, function(error) {
    showMessage("Error disabling 2FA: " + error.errorMessage);
  });
}
