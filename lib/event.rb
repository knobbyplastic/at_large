require_relative 'constants'
require 'csv'

# Used to input results of an event into the appropriate file. Creating a new
#   instance with the appropriate parameters prepares the needed instance
#   variables the #update method takes the names of placing competitors and
#   writes them to the data file.
class Event
  def initialize(tournament_name, event_name, no_of_competitors, number_breaking = [])
    @event_name = event_name
    @tournament_name = tournament_name

    # Create event file if none exists
    unless File.exist?("#{@event_name}.csv")
      File.open("#{@event_name}.csv", 'w') do |file|
        file.write("Name\nNo. of competitors")
      end
    end

    new_tournament

    @event = CSV.read("#{event_name}.csv", headers: true)
    @no_of_competitors = no_of_competitors
    @number_breaking = number_breaking
  end

  def new_tournament
    # Get file in array-of-arrays
    event = CSV.read("#{@event_name}.csv")
    # Add new tournament to first row
    event.first << @tournament_name
    # Insert 'n's in empty spaces
    event.each { |row| row << 'n' unless row.first == 'Name' }
    # Feed altered array-of-arrays back into the file
    CSV.open("#{@event_name}.csv", 'w') { |csv| event.each { |r| csv << r } }
  end

  def update(*array_of_names) # Second argument array of debate record points
    # Add number of competitors
    @event.first[@tournament_name] = @no_of_competitors

    # Iterate over competitors and add results
    array_of_names.first.each_with_index do |name, index|
      # Add place of finish
      next if name == 'n'
      if index < finalists # Check whether student is a finalist
        ie?(@event_name) ? rank_points = '' : rank_points = ":#{array_of_names.last[index]}"
        @event[find_row_number(name)][@tournament_name] = "#{index + 1}" + rank_points
      else
        @event[find_row_number(name)][@tournament_name] = 'sf'
      end
    end

    CSV.open("#{@event_name}.csv", 'w') { |csv| @event.to_a.each { |r| csv << r } }
  end

  def semifinalists
    advancing(@no_of_competitors).first
  end

  def finalists
    ie?(@event_name) ? advancing(@no_of_competitors).last : @number_breaking
  end

  private

  def new_competitor(name)
    # Add placeholder 'n' for already entered tournaments
    @event << [name, ['n'] * (@event.headers.length - 1)].flatten
  end

  def find_row_number(name)
    # Return row number given a competitor name, create competitor entry if
    #   does not exist
    new_competitor(name) unless @event['Name'].include?(name)
    @event['Name'].find_index(name)
  end
end