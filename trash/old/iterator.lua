Control.Iterator= "string"==type(Control.Iterator)
and(function(s)
        return function()
            --if #Control.operator>0 or #Control.word>0 then return end--block execution if any of quences is not empty
            Control.index,Control.operator,Control.word=s()
            return not Control.index
        end
    end)(gmatch(Control.src,Control.Iterator))
or Control.Iterator
