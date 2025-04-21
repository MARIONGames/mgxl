handlers.BanUserByUsername = function (args) {
    var username = args.username;
    var reason = args.reason || "No reason specified";
    var duration = args.durationMinutes;

    if (!username) return { error: "Username is required" };

    var accountInfo = server.GetUserAccountInfo({ Username: username });

    if (!accountInfo || !accountInfo.UserInfo || !accountInfo.UserInfo.PlayFabId)
        return { error: "User not found." };

    var playFabId = accountInfo.UserInfo.PlayFabId;

    var banEntry = {
        PlayFabId: playFabId,
        Reason: reason
    };

    if (duration) banEntry.DurationInMinutes = duration;

    var result = server.BanUsers({ Bans: [banEntry] });
    return { result: "User banned successfully", details: result };
};

handlers.UnbanUserByUsername = function (args) {
    var username = args.username;

    if (!username) return { error: "Username is required" };

    var accountInfo = server.GetUserAccountInfo({ Username: username });

    if (!accountInfo || !accountInfo.UserInfo || !accountInfo.UserInfo.PlayFabId)
        return { error: "User not found." };

    var playFabId = accountInfo.UserInfo.PlayFabId;

    var unbanResult = server.UnbanUsers({ PlayFabIds: [playFabId] });
    return { result: "User unbanned", details: unbanResult };
};
