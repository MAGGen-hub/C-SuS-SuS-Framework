
            code
                :gifsub(minify.del_comments ,"-%-[^%[].-\n","\n")                               --remove comments
                :gifsub(minify.del_spaces   ,"%s+",function(s)return s:find"\n"and"\n"or" "end) --remove useless gaps and spaces
            if minify.default_words then code
                :gsub("([^_])index","%1i") -- replace "index" with "i"
                :gsub("operator","o")
                :gsub("word([^s])","w%1")
                :gsub("native_load","nl")
                :gsub("placeholder_func","pf")
                :gsub("Features","F")
                
                :gsub("gmatch"      ,  "SM")--string lib
                :gsub("match"       ,  "Sm")
                :gsub("find"        ,  "Sf")
                :gsub("gsub"        ,  "SS")
                :gsub("sub"         ,  "Ss")
                
                :gsub("insert"      ,  "Ti")--table lib
                :gsub("concat"      ,  "Tc")
                :gsub("remove"      ,  "Tr")
                :gsub("unpack"      ,  "Tu")
            
                :gsub("floor"       ,  "Mf")--math lib
            
                :gsub("(^.)type"    ,"%1Gt")--generic lib
                :gsub("pairs"       ,  "Gp")
                :gsub("error"       ,  "Ge")
                :gsub("setmetatable",  "Gs")
                :gsub("getmetatable",  "Gg")
                :gsub("tostring"    ,  "Gt")
                :gsub("bit32"       ,  "Gb")
            
                :gsub("Ctrl"        ,   "C")
                :gsub("string_mode" ,  "sm")
                :gsub("control_string","cs")
                :gsub("temp"        ,   "t")
            
            end
        