#!/bin/env ruby
# encoding: utf-8
require "formatifier/version"
require "open-uri"

class String
  def formatify(example, strip=true, truncate=false)

    self.strip_out_all_non_word_characters unless strip == false

    delimiters = []

    example.enum_for(:scan, /(\W|\s|_)/).map { delimiters << [Regexp.last_match.to_s, Regexp.last_match.begin(0)] }

    delimiters.each do |h|
      self.insert(h.last, h.first)
    end

    if truncate
      self.slice(0...example.length)
    else
      self
    end
  end

  def to_phone(geo="us", international=true, delimiter="-")

  # China 1234 5678
  # France  01–23–45–67–89
  # Poland  (12) 345.67.89
  # Singapore 123 4567
  # Thailand  (01) 234–5678 or (012) 34–5678
  # United Kingdom  0123 456 7890 or 01234 567890
  # United States 1 (123) 456 7890

    unless nil?
      case geo.downcase
      # when :ch
      #   if international # 86 10 69445464
      #     formatify()
      #   else # (10) 69445464
      #     formatify()
      #   end
      # when :fr
      #   if international # 33 6 87 71 23 45
      #     formatify()
      #   else # 06 87 71 23 45
      #     formatify()
      #   end
      # when :po
      #   if international
      #     formatify()
      #   else
      #     formatify()
      #   end
      # when :po
      #   if international
      #     formatify()
      #   else
      #     formatify()
      #   end
      # when :sg
      #   if international # 58 295 416 72 16
      #     formatify()
      #   else # (0295) 416,72,16
      #     formatify()
      #   end
      # when :th
      #   if international # 58 295 416 72 16
      #     formatify()
      #   else # (0295) 416,72,16
      #     formatify()
      #   end
      when "uk"
        if international # 44 7700 954 321
          self.insert(0, "44") unless self.match(/^(44)/)
          formatify("xx xxxx#{delimiter}xxx#{delimiter}xxx")
        else # 07700 954 321
          formatify("xxxxx#{delimiter}xxx#{delimiter}xxx")
        end
      when "us"
        if international # 1 954 555 1234
          self.insert(0, "1") unless self.match(/^(1)/)
          formatify("x xxx#{delimiter}xxx#{delimiter}xxxx")
        else # (954) 555–1234
          formatify("(xxx) xxx#{delimiter}xxxx")
        end
      end
    end
  end

  def to_url(secure=false, subdomain="www")
    unless self.empty?
      # TODO Handle sub domains better
      protocol = secure ? "s" : ""
      domain = subdomain == false ? "" : "#{subdomain}."

      prefix = self.match(/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/|www\.)/).to_s || nil
      self.sub!(prefix, "") unless prefix.nil?

      "http#{protocol}://#{domain}#{self}"
    end
  end

  def to_ssn(delimiter="-", truncate=false)
    formatify("xxx#{delimiter}xx#{delimiter}xxxx", true, truncate)
  end

  def to_lock_combo(delimiter="-", truncate=false)
    formatify("xx#{delimiter}xx#{delimiter}xx", true, truncate)
  end

  def to_isbn
    return "invalid ISBN" unless is_valid_isbn13?(self)
    formatify("xxx-x-xx-xxxxxx-x")
  end

  def to_morse
    text = split("").each_with_index { |l, i| l.replace(transposer[self[i].downcase] || "[#{l}]")}
    text.join("").chomp(" ")
  end

  def to_pirate_speak
    base = "http://www.isithackday.com/arrpi.php?text="
    text = self.gsub(' ', '%20')
    open(base + text) {|f| f.read}
  end

  def to_leet_speak(random = false)
    text = split(/( |,)/).map{|w| leet_replace(w, random)}
    text.join.chomp(" ")
  end

protected

  def transposer
    {
      " " => "",
      "a" => "·– ",
      "b" => "–··· ",
      "c" => "–·–· ",
      "d" => "–·· ",
      "e" => "· ",
      "f" => "··–· ",
      "g" => "––· ",
      "h" => "···· ",
      "i" => "·· ",
      "j" => "·––– ",
      "k" => "–·– ",
      "l" => "·–·· ",
      "m" => "–– ",
      "n" => "–· ",
      "o" => "––– ",
      "p" => "·––· ",
      "q" => "––·– ",
      "r" => "·–· ",
      "s" => "··· ",
      "t" => "– ",
      "u" => "··– ",
      "v" => "···– ",
      "w" => "·–– ",
      "w" => "–··– ",
      "y" => "–·–– ",
      "z" => "––·· ",
      "0" => "––––– ",
      "1" => "·–––– ",
      "2" => "··––– ",
      "3" => "···–– ",
      "4" => "····– ",
      "5" => "····· ",
      "6" => "–···· ",
      "7" => "––··· ",
      "8" => "–––·· ",
      "9" => "––––· ",
      "." => "·–·–·– ",
      "," => "––··–– ",
      "?" => "··––·· ",
      "'" => "·––––· ",
      "!" => "–·–·–– ",
      "/" => "–··–· ",
      "(" => "–·––· ",
      ")" => "–·––·– ",
      "&" => "·–··· ",
      ":" => "–––··· ",
      ";" => "–·–·–· ",
      "=" => "–···– ",
      "+" => "·–·–· ",
      "–" => "–····– ",
      "_" => "··––·– ",
      "\"" => "·–··–· ",
      "$" => "···–··– ",
      "@" => "·––·–· ",
    }
  end

  def isbn_checksum(isbn_string)
    digits = isbn_string.split(//).map(&:to_i)
    transformed_digits = digits.each_with_index.map do |digit, digit_index|
      digit_index.modulo(2).zero? ? digit : digit*3
    end
    sum = transformed_digits.reduce(:+)
  end

  def is_valid_isbn13?(isbn13)
    checksum = isbn_checksum(isbn13)
    checksum.modulo(10).zero?
  end

  def isbn13_checksum_digit(isbn12)
    checksum = isbn_checksum(isbn12)
    10 - checksum.modulo(10)
  end

  def strip_out_all_non_word_characters
    self.gsub!(/(\W|\s|_)/, "")
  end

  def leet_replace(w,random)
    if leet_translations[w.downcase]
      [w.replace(leet_translations[w.downcase].send(random ? "sample" : "first"))]
    else
      w.size > 1 ? w.split("").each{|l| leet_replace(l,random)} : [w]
    end
  end

  def leet_translations
    {
      "leet"     => ["1337"],
      "the"      => ["teh"],
      "cool"     => ["kewl"],
      "dude"     => ["d00d"],
      "you"      => ["u"],
      "noob"     => ["n00b"],
      "noobs"    => ["n00bs"],
      "own"      => ["pwn"],
      "owned"    => ["pwned"],
      "rocks"    => ["roxx0rs"],
      "exploits" => ["sploitz"],
      "woot"     => ["w00t"],
      "hacker"   => ["hax0r"],
      "hackers"  => ["hax0rz"],
      "a"        => ["4","@"],
      "b"        => ["8","]3","]8","|3","|8","13"],
      "c"        => ["(","{"],
      "d"        => [")","[}","|)","|}","|>"],
      "e"        => ["3"],
      "f"        => ["|=","ph"],
      "g"        => ["6","9","&"],
      "h"        => ["#","|-|"],
      "i"        => ["1","!","|"],
      "j"        => ["_|","u|"],
      "k"        => ["|<", "|{"],
      "l"        => ["|","1","|_"],
      "m"        => ["/\\/\\","|\\/|"],
      "n"        => ["/\\/", "|\\|"],
      "o"        => ["0", "()"],
      "p"        => ["|D", "|*"],
      "q"        => ["(,)","O\\","[]\\"],
      "r"        => ["|2", "|?","][2"],
      "s"        => ["5","$"],
      "t"        => ["7","+"],
      "u"        => ["(_)", "|_|"],
      "v"        => ["\\/" ,"\\\\//"],
      "w"        => ["\\/\\/","|/\\|","VV"],
      "x"        => ["><", "}{"],
      "y"        => ["'/","%"],
      "z"        => ["2","7_"]
    }
  end
end
