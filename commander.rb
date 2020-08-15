# frozen_string_literal: true

require_relative 'Rules/elevator_caller'
require_relative 'Rules/disabled_floors_rules'
require_relative 'Rules/elevator_direction_rules'
require_relative 'Enums/direction'

# The Commander will command the Elevator and what floors to stop at
class Commander
  include ElevatorCaller
  include DisabledFloorsRules
  include ElevatorDirectionRules
  attr_reader :current_direction
  def initialize(floors)
    @current_direction = Direction::UP
    @floors = floors
    @floors_up = []
    @floors_down = []
    @current_floor = floors[0]

    populate_floors(floors)
  end

  def call(floor) end

  private

  def disabled_floors_up
    [0]
  end

  def disabled_floors_down(number_of_floors)
    [number_of_floors]
  end

  def populate_floors(floors)
    disabled_up = disabled_floors_up()
    disabled_down = disabled_floors_down(floors.length)

    floors.each do |floor|
      @floors_up.push({ floor: floor, available?: !disabled_up.include?(floor), called?: false })
      @floors_down.push({ floor: floor, available?: !disabled_down.include?(floor), called?: false })
    end
  end

  def dock?
    people.none? && calls_from_above.none? && calls_from_below.none?
  end

  def dock
    @current_floor = @floors[0]
    @current_direction = Direction::None
  end

  def calls_from_above
    @floors_up.union(@floors_down).filter(&:called?).any { |f| f.floor.number > @current_floor.number }
  end

  def calls_from_below
    @floors_up.union(@floors_down).filter(&:called?).any { |f| f.floor.number < @current_floor.number }
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
      @current_floor = @floors_down.filter(&:called?).max(&:floor.number)
    elsif @current_direction == Direction::DOWN
      @current_direction = DIRECTION::UP
      @current_floor = @floors_up.filter(&:called?).min(&:floor.number)
    end
  end
end
