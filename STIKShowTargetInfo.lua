-- Проверить расстоянине до цели и показать значок атаки ближнего боя, если необходимо --

function showTargetInfo(selectionType)
    if (not(playerInfo.settings.isEventStarted)) then
        return nil;
    end;

    local currentPlot = playerInfo.settings.currentPlot;
    if (not(playerInfo[currentPlot])) then
        return nil;
    end;

    local flags = playerInfo[currentPlot].flags;

    local targetName = UnitName("target");
    local isTargetExists = not (targetName == nil)
    local isTargetPlayer = UnitPlayerControlled("target")

    if (isTargetExists and not isTargetPlayer) then
        local canBeAttackedMelee = CheckInteractDistance("target", 3);
        if (canBeAttackedMelee) then
            targetInfoFrame.AttackablePanel:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_ok.blp");
            targetInfoFrame.AttackablePanel:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_ok.blp");
            targetInfoFrame.AttackablePanel.hint = STIKConstants.texts.canBeAttacked.ok;
        else
            targetInfoFrame.AttackablePanel:SetNormalTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_not.blp");
            targetInfoFrame.AttackablePanel:SetHighlightTexture("Interface\\AddOns\\STIKSystem\\IMG\\canBeAttacked_not.blp");
            targetInfoFrame.AttackablePanel.hint = STIKConstants.texts.canBeAttacked.notOK;
        end
    
        if (flags.isInBattle == 1) then targetInfoFrame:Show();
        else targetInfoFrame:Hide();
        end;
    else targetInfoFrame:Hide();
    end
end;
