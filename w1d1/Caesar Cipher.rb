def cesar_cipher(string, n)
	lcase=*("a".. "z" )
	ucase=*("A".."Z")
	new_word=[]
	def new_ucase_letter(c,n)
		ucase=*("A".."Z")
		if (ucase.index(c)+n)>25
			wrap=(ucase.index(c)+n)-26
			new_word << ucase[wrap]
		elsif
			new_word << ucase[lcase.index(c)+n]
		else
			new_word << c
		end
	end
	def new_lcase_letter(c,n)
		lcase=*("a".. "z" )
		if lcase.include? c
			if (lcase.index(c)+n)>25
				wrap=(lcase.index(c)+n)-26
				new_word << lcase[wrap]
			elsif
				new_word << lcase[lcase.index(c)+n]
			else
				new_word << c
			end
		end
	end
	string.split("").each do |c| 
		for lcase.include? c
			new_lcase_letter(c,n)
 		end
 		for ucase.include? c
 			new_lcase_letter(c,n)
 		end
	end
	new_word.join

end






p new_lcase_letter("z",3)

cesar_cipher("How are you?", 2)

