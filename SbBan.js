handlers.banPlayer = function (args, context) {
    var banRequest = {
        PlayFabId: currentPlayerId,
        Reason: args.reason || "Cheating",
        DurationInHours: args.permanent ? null : 720
    };

    var result = server.BanUsers({
        Bans: [banRequest]
    });

    return { result: result };
};
