require_relative 'constants'
require 'csv'

# Contains methods for calculating and exporting standings (from
#   #find_standings down) as well as three miscellaneous methods, #median, used
#   when calculating points for semifinal placings, #ie?, used when debate
#   events need to be treated differently, and #advancing, used by class Event
#   and atlarge calculations to find how many students break to finals and
#   semifinals depending on number of competitors.
module AtLarge
  def median(array)
    # http://stackoverflow.com/questions/14859120/calculating-median-in-ruby
    (array[(array.size - 1) / 2] + array[array.size / 2]) / 2.0
  end

  def ie?(abbr)
    !(abbr == 'tp' || abbr == 'ld')
  end

  def advancing(no_of_competitors)
    NUMBER_ADVANCING.select { |k, _| k.include?(no_of_competitors) }
      .to_a.first.last # Extract desired number from [[some_num, another_num]]
  end

  def find_standings
    results = {} # {:ads => {"John Doe" => 13.45, "Jane Doe" => 11.3, ...}, etc

    LIST_OF_EVENTS.each do |event_name, abbr|
      next unless File.exist?("#{abbr}.csv")

      # Sort scores from highest to lowest
      points = find_scores(abbr).sort { |x, y| y.last <=> x.last }.to_h

      # Round all the scores to one decimal place
      results[event_name] =
        points.each { |name, number| points[name] = number.round(1) }
    end

    results
  end

  def find_scores(event)
    data = CSV.read("#{event}.csv", headers: true)
    points = {}

    # Get all the students in the event and find their scores
    data['Name'].each do |name|
      next if name.nil? || name == 'No. of competitors'
      points[name] = find_score(name, data)
    end

    points
  end

  def find_score(name, data)
    find_results(name, data).map do |result|
      find_place_points(result.last.split(':').first,
                        data.first[result.first].to_f) \
                        + find_record_points(result)
    end.compact.sort.last(3).inject(:+) # Add three highest scores
  end

  def find_results(name, data)
    # Get an array-of-arrays that contains places and the tournament
    #   corresponding with that place.
    data[data['Name'].find_index(name)].to_a
  end

  def find_record_points(placing)
    # Extract record points only if the event is debate. This is determined
    #   by checking whether the results contain a ':'. Otherwise return a
    #   zero (to prevent a TypeError when adding).
    placing.last.include?(':') ? placing.last.split(':').last.to_i : 0
  end

  def find_place_points(place, no_of_competitors)
    # See "Individual Events Tabulation Rules and Guidelines" and "Debate
    #   Tabulation Rules and Guidelines", from ncfca.org.
    case place
    when 'sf'
      no_of_competitors / semifinal_estimate(no_of_competitors)
    when '1'
      (no_of_competitors / 2) + 1
    when /^\d+$/
      no_of_competitors / place.to_i
    else
      0
    end
  end

  def semifinal_estimate(no_of_competitors)
    # Construct a range starting with the highest possible place and ending
    #   with the last possible place, then find the median place.
    median(Range.new((advancing(no_of_competitors).last + 1),
                     (advancing(no_of_competitors).first)).to_a)
  end

  def generate_file(results)
    filename = "atlarge-export-#{Time.new.strftime('%b-%d-%Y--%k.%M')}.txt"

    File.open(filename, 'w') do |file|
      results.each do |event_name, rankings|
        next if rankings.empty? # Don't export events with no data
        file.write("#{event_name}\n\n")
        # Get the results in the proper format for every student
        rankings.each { |name, points| file.write(format_line(name, points)) }
        file.write('_' * 50 + "\n\n")
      end

      file.write("Generated: #{Time.now}")
    end

    puts "Standings successfully exported as #{filename}"
  end

  def format_line(name, points)
    # Each line is fifty characters long. Finds size of name and points and
    #   fills in space between with periods.
    name + '.' * (50 - (name.size + points.to_s.size)) + points.to_s + "\n"
  end
end
