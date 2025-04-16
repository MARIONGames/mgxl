handlers.BanPlayer = function (args, context) {
    var reason = args.reason || "No reason provided";
    var durationMinutes = args.durationMinutes || 1440;

    var durationSeconds = durationMinutes * 60;

    var banRequest = {
        PlayFabId: currentPlayerId,
        Reason: reason,
        DurationInSeconds: durationSeconds
    };

    var result = server.BanUsers({ Bans: [banRequest] });
    return { message: "Player banned for " + durationMinutes + " minute(s)", banDetails: result.BanData };
};
