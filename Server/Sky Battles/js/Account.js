window.addEventListener('DOMContentLoaded', () => {
    const status = document.getElementById('status');

    const userSession = localStorage.getItem('PlayFabSessionTicket');
    const playerId = localStorage.getItem('PlayFabId');

    if (!userSession || !playerId) {
        status.textContent = "You must login from the game.";
        return;
    }

    PlayFab.settings.titleId = "YOUR_TITLE_ID"; // Replace this

    document.getElementById('updateDisplayName').addEventListener('click', () => {
        const name = document.getElementById('displayName').value;
        PlayFabClientSDK.UpdateUserTitleDisplayName({
            DisplayName: name
        }, (result) => {
            status.textContent = `Display name updated to ${result.data.DisplayName}`;
        }, (error) => {
            status.textContent = `Error: ${error.errorMessage}`;
        });
    });
});
