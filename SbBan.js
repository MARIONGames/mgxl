handlers.BanPlayer = function (args, context) {
    var reason = args.reason || "No reason provided";
    var durationMinutes = args.durationMinutes;
    var username = args.username;

    var accountInfo = server.GetUserAccountInfo({ Username: username });
    var playFabId = accountInfo.UserInfo.PlayFabId;

    var banRequest = {
        PlayFabId: playFabId,
        Reason: reason
    };

    if (durationMinutes === 0) {
        banRequest.Permanent = true;
    } else {
        banRequest.DurationInSeconds = durationMinutes * 60;
    }

    var result = server.BanUsers({ Bans: [banRequest] });

    return {
        message: durationMinutes === 0 ? "Player permanently banned" : ("Player banned for " + durationMinutes + " minute(s)"),
        banDetails: result.BanData
    };
};
