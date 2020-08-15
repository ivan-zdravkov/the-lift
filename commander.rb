# frozen_string_literal: true

require_relative 'modules/elevator_caller'
require_relative 'modules/disabled_floors'
require_relative 'modules/elevator_direction'
require_relative 'enums/direction'

# The Commander will command the Elevator and what floors to stop at
class Commander
  include ElevatorCaller
  include DisabledFloors
  include ElevatorDirection
  attr_reader :current_direction
  attr_reader :current_floor
  def initialize(floors)
    @current_direction = Direction::UP
    @floors = floors
    @floors_up = []
    @floors_down = []
    @current_floor = floors[0]

    populate_floors(floors)
  end

  def call(floor) end

  def move_next_floor
    if @commander.change_direction?
      @current_floor = @commander.change_direction
    else
      if @current_direction == Direction::UP
        @current_floor = @floors_up.first { |floor| floor.called? && floor.number > @current_floor.number }
      elsif @current_direction == Direction::DOWN
        @current_floor = @floors_down.last { |floor| floor.called? && floor.number < @current_floor.number }
      end
    end
  end

  def dock?
    people.none? && calls_from_above.none? && calls_from_below.none?
  end

  def dock
    @current_floor = @floors[0]
    @current_direction = Direction::NONE
  end

  def change_direction?(people)
    if @current_direction == Direction::UP
      people.none? && calls_from_above.none?
    elsif @current_direction == Direction::DOWN
      people.none? && calls_from_below.none?
    end
  end

  def change_direction
    if @current_direction == Direction::UP
      @current_direction = Direction::DOWN
      @floors_down.filter(&:called?).max(&:floor.number)
    elsif @current_direction == Direction::DOWN
      @current_direction = DIRECTION::UP
      @floors_up.filter(&:called?).min(&:floor.number)
    end
  end

  private

  def disabled_floors_up
    [0]
  end

  def disabled_floors_down(number_of_floors)
    [number_of_floors]
  end

  def populate_floors(floors)
    disabled_floors_down = disabled_floors_down(floors.length)

    floors.each do |floor|
      @floors_up.push({ floor: floor, available?: !disabled_floors_up.include?(floor), called?: false })
      @floors_down.push({ floor: floor, available?: !disabled_floors_down.include?(floor), called?: false })
    end
  end

  def calls_from_above
    @floors_up.union(@floors_down).filter(&:called?).any { |f| f.floor.number > @current_floor.number }
  end

  def calls_from_below
    @floors_up.union(@floors_down).filter(&:called?).any { |f| f.floor.number < @current_floor.number }
  end
end
