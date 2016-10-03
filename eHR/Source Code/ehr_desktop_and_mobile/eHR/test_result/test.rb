#obj = ActionBuilder.new()

puts [true, true, true, false].uniq.length

#----------------------
str_code = "90-999"

2.times do
arr_temp = str_code.split("-")
num_ascii = arr_temp.first.to_i
num_id = arr_temp.last.to_i

puts "------------#{num_ascii.chr}#{num_id}----------"

if num_id == 999
  if num_ascii == 90
    num_ascii = 65
  else
    num_ascii += 1
  end
  num_id = 100
else
  num_id += 1
end
str_code = "#{num_ascii}-#{num_id}"
end

puts "----------------------"
#str = "return  ChangeAllergyStatus('4730','1','status1');"
#puts str.split("return").last.strip

#English Units: BMI = Weight (lb) / (Height (in) x Height (in)) x 703
w = 132.277  # in pounds
h = 65  # in inches
bmi = w/(h*h)*703
puts "weight : #{w} bls"
puts "height : #{h} inches"
puts "BMI    : #{bmi.round(0)}"

def fun
num=1
val = case num
        when 1
          "one"
        when 2
          puts 111111111111111111
          1==1 ? 'yes' : 'no'
        else
          raise "some error"
      end
end

puts fun