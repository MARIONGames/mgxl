handlers.BanPlayer = function (args, context) {
    var reason = args.reason || "No reason provided";
    var durationMinutes = args.durationMinutes;

    var banRequest = {
        PlayFabId: currentPlayerId,
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
