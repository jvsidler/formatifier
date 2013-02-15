# Formatifier

	Quick and dirty string formatter

## Installation

Add this line to your application's Gemfile:

    gem 'formatifier'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install formatifier

## Disclaimer

Testing and Documentation are forthcoming. Just threw this together so functionality will probably change. Feel free to contribute!

## Usage

### Specify outcome explicitly
```ruby
irb> "5553459877".formatify("(xxx) xxx-xxxx")
 => "(555) 345-9877"
```

### Use convenience methods
```ruby
irb> "5553459877".to_phone("us")
 => "1 555-345-9877"
irb> "5553459877".to_phone("us", false)
 => "(555) 345-9877"
irb> "5553459877".to_phone("us", false, ".")
 => "(555) 345.9877"
irb> "5553459877".to_phone("us", true, ".")
 => "1 555.345.9877"
irb> "5553459877".to_phone("uk", false)
 => "55534-598-77"
irb> "5553459877".to_phone("uk")
 => "44 5553-459-877"
irb> "(555)345-9877".to_phone("us", true, ".")
 => "1 555.345.9877"
irb> "(555)345-9877".to_phone("us", false, ".")
 => "(555) 345.9877"

irb> "999999999".to_ssn
 => "999-99-9999"
irb> "999999999".to_ssn(".")
 => "999.99.9999"
irb> "99999999999999999999".to_ssn(".")
 => "999.99.999999999999999"
irb> "99999999999999999999".to_ssn(".", true)
 => "999.99.9999"

irb> "999999".to_lock_combo
 => "99-99-99"
irb> "999999".to_lock_combo("_")
 => "99_99_99"
irb> "9999999999999".to_lock_combo("_", true)
 => "99_99_99"
irb> "9999999999999".to_lock_combo(".", true)
 => "99.99.99"

irb> "domain.com".to_url
 => "http://www.domain.com"
irb> "domain.com".to_url(true)
 => "https://www.domain.com"
irb> "domain.com".to_url(true, "sub")
 => "https://sub.domain.com"
irb> "domain.com".to_url(false, "sub")
 => "http://sub.domain.com"

irb> "This gem is stringtastic!".to_morse
 => "– ···· ·· ··· ––· · –– ·· ··· ··· – ·–· ·· –· ––· – ·– ··· – ·· –·–· –·–·––"
```

### Use Awesomeness
```ruby
irb> "This gem is awesome!".to_pirate_speak
 => "This gem be awesome!"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
