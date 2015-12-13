require 'digest'

md5 = Digest::MD5.new
initial_input = "bgvyzdsv"
digest_has_five_leading_zeros = false
num = 0
until digest_has_five_leading_zeros
  num += 1
  digest = md5.hexdigest(initial_input + num.to_s)
  digest_has_five_leading_zeros = digest.start_with? "000000"
end

puts "lowest positive number is #{num}"