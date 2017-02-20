require 'deep_clone'
require './models/multiplication'
require './models/power'
require './models/addition'
require './models/variables'
require './models/numerals'
require './models/factory'

include ClassName
include Factory

exp = mtp('x', 3, mtp(2,pow('x',2)))
# exp.standardize_args
# result = exp.simplify_product_of_m_forms
exp_clone = DeepClone.clone exp
