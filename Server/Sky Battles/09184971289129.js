handlers.GetClientData = function (args)
{
    type = "title_player_account"
    Client = "match"
    args[1] = UpdateClientData
    args[2] = ViewClientData
    args[3] = DeleteClientData
    args[4] = BanPlayer
};

handlers.BanPlayer = function (args)
{
    var reason = "Exploting / Cheating"
    var time = 0
    var accountInfo = server.GetUserAccountInfo({ Username: username });
    var banRequest = {
        PlayFabId: playFabId,
        Reason: reason
    };
    if (durationMinutes === 0) {
        banRequest.Permanent = true;
    }
};