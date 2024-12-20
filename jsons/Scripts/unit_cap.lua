-- unit_cap.lua
function onTurnStart(turn, civilization)
    local totalPopulation = 0
    local totalUnits = 0
    
    -- Calculate total population
    for _, city in ipairs(civilization.cities) do
        totalPopulation = totalPopulation + city.population
    end
    
    -- Count total non-great-person units
    for _, unit in ipairs(civilization.units) do
        if not unit.name:find("Great") then
            totalUnits = totalUnits + 1
        end
    end
    
    -- If units exceed population, destroy random units until we're at limit
    while totalUnits > totalPopulation do
        local validUnits = {}
        for _, unit in ipairs(civilization.units) do
            if not unit.name:find("Great") then
                table.insert(validUnits, unit)
            end
        end
        
        if #validUnits > 0 then
            local randomIndex = math.random(#validUnits)
            validUnits[randomIndex]:kill()
            totalUnits = totalUnits - 1
            civilization:addNotification("Unit disbanded due to population cap!")
        end
    end
end

-- Prevent unit creation if at cap
function onUnitTrained(unit, city)
    local civ = city.civilization
    local totalPopulation = 0
    local totalUnits = 0
    
    for _, cityCount in ipairs(civ.cities) do
        totalPopulation = totalPopulation + cityCount.population
    end
    
    for _, unitCount in ipairs(civ.units) do
        if not unitCount.name:find("Great") then
            totalUnits = totalUnits + 1
        end
    end
    
    if totalUnits >= totalPopulation and not unit.name:find("Great") then
        unit:kill()
        civ:addNotification("Cannot create new unit - population limit reached!")
        return false
    end
    
    return true
end