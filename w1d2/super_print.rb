def super_print(string, opts = {})
  defaults = {
    :times => 1,
    :upcase => false,
    :reverse => false
  }
    defaults.merge!(opts)

    string.upcase! if defaults[:upcase]
    string.reverse! if defaults[:reverse]
    string*defaults[:times]
end


