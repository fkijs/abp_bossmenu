local function IsPlayerBoss(Player)
    if Player == nil or Player.PlayerData == nil or Player.PlayerData.job == nil then
        return false
    end

    local jobName = Player.PlayerData.job.name
    local jobGradeTable = Player.PlayerData.job.grade

    if jobName == nil or jobGradeTable == nil then
        return false
    end

    local jobGrade = tonumber(jobGradeTable.level)
    if jobGrade == nil then
        return false
    end

    local bossGrade = Config.BossGrades[jobName]
    if bossGrade == nil then
        return false
    end

    return jobGrade >= bossGrade
end

return IsPlayerBoss