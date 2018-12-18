local spellbook = {}

spellbook.preamble = function()
    local ret = {}
    if os.getenv('DEBUG') then
        table.insert(ret, '\\renewcommand{\\wizpenfont}{\\normalfont}')
    end
    return ret
end

spellbook.match = function(str, pattern, iftrue, iffalse)
    if string.match(str, pattern) then
        return iftrue
    else
        return iffalse
    end
end

local trim = function(str)
    return str:gsub('^%s*(.-)%s*$', '%1')
end

spellbook.dice = function(str)
    local ret = str:gsub('(%d+)d(%d+)(%s*[%+%-]?%s*%d*)', function(x, y, plus)
        x = tonumber(x) or 0
        y = tonumber(y) or 0
        plus = tonumber(plus) or 0

        local dice = string.format('%dd%d%+d', x, y, plus)
        if x <= 0 or y <= 0 then
            error('invalid dice: ' .. dice)
        else
            print('dice: ' .. dice)
        end

        if plus ~= 0 then
            local sign
            if plus < 0 then
                sign = '-'
            else
                sign = '+'
            end
            return string.format('\\SpellbookDiceFourArg{%d}{%d}{%s}{%d}', x, y, sign, math.abs(plus))
        else
            return string.format('\\SpellbookDiceTwoArg{%d}{%d}', x, y)
        end
    end)

    print(str .. ' => ' .. ret)
    return ret
end

spellbook.distance = function(str)
    return trim(str):gsub('(%d+)[%s%-]+foot', function(x)
        x = tonumber(x) or 0

        local distance = string.format('%d foot', x)
        if x <= 0 then
            error('invalid distance: ' .. distance)
        else
            print('distance: ' .. distance)
        end

        return string.format('\\SpellbookDistanceOneArg{%d}', x)
    end)
end

spellbook.range = function(str)
    return trim(str):gsub('(%d+)/(%d+)', function(x, y)
        x = tonumber(x) or 0
        y = tonumber(y) or 0

        local range = string.format('%d/%d', x, y)
        if x <= 0 or y <= 0 then
            error('invalid range: ' .. range)
        else
            print('range: ' .. range)
        end

        return string.format('\\SpellbookRangeTwoArg{%d}{%d}', x, y)
    end)
end

spellbook.cleanup = (function()
    local fixup_ws = function(str)
        return str:gsub('%s+', ' ')
    end

    local cleanup = function(str)
        --return str:gsub("[^A-Za-z0-9%s.,'\\/]", '')
        return str:gsub("[^A-Za-z0-9%s%-%+/\\]", '')
    end

    local add_breaks = function(str)
        return str:gsub('\\par', '\\\\ \\\\ \\par')
    end

    local transforms = {
        trim,
        fixup_ws,
        cleanup,
        spellbook.dice,
        spellbook.distance,
        spellbook.range,
        add_breaks
    }

    return function(str)
        for i, fn in ipairs(transforms) do
            str = fn(str)
        end
        print(str)
        return str
    end
end)()

return spellbook
