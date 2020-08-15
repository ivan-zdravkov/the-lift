# frozen_string_literal: true

# The Floor will keep the people and have a Command Interface to call the Elevator
class Floor
  def initialize(number, commander, people)
    @number = number
    @commander = commander
    @waiting = people
    @arrived = []
  end

  def give_person
    if @waiting.length.positive?
      person = @waiting.shift

      person
    end

    nil
  end

  def get_person(person)
    @arrived.push(person)
  end

  def call_elevator
    @commander.call(@number) unless @waiting.length.zero?
  end
end
