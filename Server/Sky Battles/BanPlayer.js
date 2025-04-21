handlers.BanUserByUsername = function (args) {
    var username = args.username;
    var reason = args.reason || "No reason specified";
    var duration = args.durationMinutes;

    if (!username) return { error: "Username is required" };

    var userResult = server.GetUserInternalData({ Keys: [username] });
    var playFabId = userResult.Data[username];

    if (!playFabId) return { error: "User not found." };

    var banEntry = {
        PlayFabId: playFabId,
        Reason: reason
    };

    if (duration) {
        banEntry.DurationInMinutes = duration;
    }

    var result = server.BanUsers({ Bans: [banEntry] });
    return { result: "User banned successfully", details: result };
};

handlers.UnbanUserByUsername = function (args) {
    var username = args.username;

    if (!username) return { error: "Username is required" };

    var userResult = server.GetUserInternalData({ Keys: [username] });
    var playFabId = userResult.Data[username];

    if (!playFabId) return { error: "User not found." };

    var unbanResult = server.UnbanUsers({ PlayFabIds: [playFabId] });
    return { result: "User unbanned", details: unbanResult };
};
