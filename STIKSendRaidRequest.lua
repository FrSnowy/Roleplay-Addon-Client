function sendRaidRequest()
    if (SHOULD_ACCEPT_NEXT_INVITE) then
        StaticPopup_Hide("PARTY_INVITE");
        SendAddonMessage("STIK_PLAYER_ANSWER", "maybe_raid", "WHISPER", MASTER);
        MASTER = nil;
        SHOULD_ACCEPT_NEXT_INVITE = false;
    end;
end;