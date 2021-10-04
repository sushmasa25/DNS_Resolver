def get_command_line_argument
 # ARGV is an array that Ruby defines for us,
 # which contains all the arguments we passed to it
 # when invoking the script from the command line.
 # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines

dns_raw = File.readlines("zone")


def parse_dns(dns_raw)
  dns_raw.each do |line|
    array = line.split(",")

    if array[0] == "A"
    
    #removed the empty spaces using strip method
      $A_hash[array[1].strip] = array[2].strip
    elsif array[0] == "CNAME"
      $CNAME_hash[array[1].strip] = array[2].strip
    end
  end
  #empty hash dnsrecords
  dnsrecord = {}
  dnsrecord[:A_hash] = $A_hash
  dnsrecord[:CNAME_hash] = $CNAME_hash
  return dnsrecord
end

$A_hash = {}
$CNAME_hash = {}

def resolve(dns_records, lookup_chain, new_domain)
  if dns_records[:A_hash][new_domain]
    lookup_chain.append(dns_records[:A_hash][new_domain])
    return lookup_chain
  elsif dns_records[:CNAME_hash][new_domain]
    lookup_chain.append(dns_records[:CNAME_hash][new_domain])
    resolve(dns_records, lookup_chain, dns_records[:CNAME_hash][new_domain])
  else
    puts "Error:record not found for #{new_domain}"
    return lookup_chain
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")


