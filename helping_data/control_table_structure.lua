control = {
    detection_pattern = main_text_separation_part
    Core = placeholder_func or core_func -- ONLY FUNCTION NOT A TABLE
    line = 1 -- line counter
    
    Result = {} -- table with result
    Operator = {} -- table with loaded operators
    Word = {} -- table with loaded words
    Finaliser = {} -- table with finaliser funcs
    Structure = {  -- system that locates structures (such as strings, numbers and comments) and wraps them into solid text parts
            structure_mode=false
    	    start_detector() --return: structure_start_detected,cutted_operator,cutted_word
    	    end_detector()   --return: structure_fin_detected,cutted_operator,cutted_word
    	}
}

--Lang_Core_41
control (with_default_core) = {
    previous_value=1  --value with type of previous code part
    current_value=nil --value with type of current  code part
    
    Level = { --code level and statement controlling module
    	Level_ctrl = level_control_function
    	type_of_lvl = "main" --"thing" that opened a level (used to search for level ends)
    	on_lvl_open = {} --table with functions that executes after level opening
    	on_lvl_close = {} --table with functions that executes after level close
    	
    	__LVL_ARRAY__ = {{{
    		Stat_priority = {} -- statement {priority,index} quence
    	}}}
    }
    Event = { --event invocation and reaction system
    	Word = {} -- variable_names 
    	Number = {}
    	String = {}
    	Value = {} --
    	Keyword = {}
    	Operator = {}
    	All = {}
    }
    
    inject_local_data --function that injects local data at script start
    register_operator
    subscribe_on_event
    prioritized_wrap --function that replaces operator with binary function call using operators priority
    	__SETS_SPECIFIC__ -- prioritized wrap registers special function to system that detects priority downgrade
    
    assert_next() --проверка следующего значения на ссответствие определенному типу
    

}

--NEW CORE CALL: CORE(object,object_info)

