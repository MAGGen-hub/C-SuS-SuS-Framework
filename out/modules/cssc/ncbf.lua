local react = C:load_lib"text.dual_queue.make_react"("..",2)
Operators[".."]=function() _G.print(Cdata[#Cdata-1][1])if 6==Cdata[#Cdata][1]then Cssc.inject(" ",5)end react()end