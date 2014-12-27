require_relative 'event'
require_relative 'at_large'
include AtLarge

loop do
  print 'Enter a command: '
  case gets.chomp
    when 'new'
      # Run through process for adding new tournament
      print 'Enter name of new tournament: '
      tournament_name = gets.chomp

      # Cycle through every event in the router
      LIST_OF_EVENTS.each do |event_name, abbr|
        print %(How many students/teams competed in #{event_name}?
              (enter "0" if you wish to skip this event) )
        number_of_competitors = gets.chomp.to_i
        next if number_of_competitors.zero?
        # Create a new array the placing competitors can be put in
        placed_competitors = []
        # Create a new array the debate record points can be put in
        record_points = []

        unless ie?(abbr)
          print "How many students/teams broke in #{event_name}? "
          number_breaking = gets.chomp.to_i
        end

        event = Event.new(tournament_name, abbr,
                          number_of_competitors,
                          (number_breaking if defined?(number_breaking)))

        puts %(Enter the name of the competitor for each place in #{event_name}"
             (if from outside of region, enter "n"))
        # Add all the finalists to the placed_competitors array
        event.finalists.times do |iteration|
          print "#{iteration + 1}. "
          name = gets.chomp
          placed_competitors << name
          unless ie?(abbr)
            print "How many record points did #{name} receive? "
            record_points << gets.chomp
          end
        end

        if ie?(abbr)
          # Add all the semifinalists to the placed_competitors array
          (event.semifinalists - event.finalists).times do
            print 'SF. '
            placed_competitors << gets.chomp
          end
        end

        # Add the results for the event (and the record points if they exist)
        event.update(placed_competitors, record_points)
      end
    when 'export'
      # Export TXT of standings
      generate_file(find_standings)
    when 'exit'
      break
    else
      puts 'Sorry, that is not a valid command'
  end
end
