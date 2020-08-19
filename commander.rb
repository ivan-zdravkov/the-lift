# frozen_string_literal: true

require_relative 'modules/caller'
require_relative 'modules/engine'
require_relative 'modules/disabled_floors'
require_relative 'enums/direction'
require_relative 'button'

# The Commander commands the Elevator via the ElevatorCaller and operates it via the ElevatorEngine
class Commander
  include Caller
  include Engine
  include DisabledFloors

  attr_reader :current_direction
  attr_reader :current_floor
  attr_reader :previous_floor

  def initialize(floors)
    @floors = floors
    @current_floor = floors.first
    @previous_floor = nil
    @current_direction = Direction::UP
    @calls_up = []
    @calls_down = []

    populate_buttons(floors)
  end

  def call_all
    @floors.each { |floor| call(floor) }
  end

  def change_floor(people)
    @previous_floor = @current_floor

    if revert_at_maximum?(people)
      @current_floor = revert_at_maximum
    else
      if @current_direction == Direction::UP
        @current_floor = next_called_floor
      elsif @current_direction == Direction::DOWN
        @current_floor = previous_called_floor
      end
    end
  end

  def arrive
    if @current_direction == Direction::UP
      @calls_up[@current_floor.number].called = false
    elsif @current_direction == Direction::DOWN
      @calls_down[@current_floor.number].called = false
    end
  end

  def call_from_the_outside
    call(@previous_floor) if @previous_floor.anyone_waiting?
  end

  def call_from_the_inside(people)
    people.each { |person| call_floor(person.destination_floor) }
  end

  def stop_moving?(people)
    people.none? && !calls_from_above && !calls_from_below
  end

  def stop_moving
    @current_floor = @floors[0]
    @current_direction = Direction::NONE
  end

  private

  def call(floor)
    @calls_up[floor.number].called = true if floor.anyone_up? && @calls_up[floor.number].available
    @calls_down[floor.number].called = true if floor.anyone_down? && @calls_down[floor.number].available
  end

  def call_floor(number)
    if number > @current_floor.number
      @calls_up[number].called = true if @calls_up[number].available
    elsif number < @current_floor.number
      @calls_down[number].called = true if @calls_down[number].available
    end
  end

  def next_called_floor
    next_call = @calls_up.select { |call| call.called && call.floor.number > @current_floor.number }.first

    next_call.nil? ? @calls_up.select(&:called).first&.floor : next_call.floor
  end

  def previous_called_floor
    previous_call = @calls_down.select { |call| call.called && call.floor.number < @current_floor.number }.last

    previous_call.nil? ? @calls_down.select(&:called).last&.floor : previous_call.floor
  end

  def disabled_floors_up
    [0]
  end

  def disabled_floors_down(number_of_floors)
    [number_of_floors]
  end

  def populate_buttons(floors)
    disabled_floors_down = disabled_floors_down(floors.length)

    floors.each do |floor|
      @calls_up.push(Button.new(floor, available: !disabled_floors_up.include?(floor)))
      @calls_down.push(Button.new(floor, available: !disabled_floors_down.include?(floor)))
    end
  end

  def calls_from_above
    @calls_up.any?(&:called)
  end

  def calls_from_below
    @calls_down.any?(&:called)
  end

  def max_floor
    @calls_down.select(&:called).max { |a, b| a.floor.number <=> b.floor.number }.floor
  end

  def min_floor
    @calls_up.select(&:called).min { |a, b| a.floor.number <=> b.floor.number }.floor
  end

  def revert_at_maximum?(people)
    if @current_direction == Direction::UP
      people.none? && !calls_from_above
    elsif @current_direction == Direction::DOWN
      people.none? && !calls_from_below
    end
  end

  def revert_at_maximum
    if @current_direction == Direction::UP
      @current_direction = Direction::DOWN
      max_floor
    elsif @current_direction == Direction::DOWN
      @current_direction = Direction::UP
      min_floor
    end
  end
end
