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

  def initialize(number_of_floors)
    @current_direction = Direction::UP
    @floors_up = []
    @floors_down = []
    @current_floor = 0

    populate_floors(number_of_floors)
  end

  def call(floor) end

  private

  def disabled_floors_up
    [0]
  end

  def disabled_floors_down(number_of_floors)
    [number_of_floors]
  end

  def populate_floors(number_of_floors)
    disabled_up = disabled_floors_up()
    disabled_down = disabled_floors_down(number_of_floors)

    number_of_floors.times do |floor|
      @floors_up.push({ floor: floor, available?: !disabled_up.include?(floor), called?: false })
      @floors_down.push({ floor: floor, available?: !disabled_down.include?(floor), called?: false })
    end
  end

  def dock?
    people.none? && calls_from_above.none? && calls_from_below.none?
  end

  def dock
    @current_floor = 0
    @current_direction = Direction::None
  end

  def calls_from_above
    @floors_up.union(@floors_down).filter(&:called?).any { |f| f.floor > @current_floor }
  end

  def calls_from_below
    @floors_up.union(@floors_down).filter(&:called?).any { |f| f.floor < @current_floor }
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
      @current_floor = @floors_down.filter(&:called?).max(&:floor)
    elsif @current_direction == Direction::DOWN
      @current_direction = DIRECTION::UP
      @current_floor = @floors_up.filter(&:called?).min(&:floor)
    end
  end
end
