-- Принять группу, когда мастер приглашает --
function acceptEventInvite()
    if (SHOULD_ACCEPT_NEXT_INVITE) then
        AcceptGroup();
    end;
end;