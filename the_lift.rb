# frozen_string_literal: true

require_relative 'elevator'
require_relative 'floor'
require_relative 'person'
require_relative 'commander'

floors = [
  Floor.new(0, []),
  Floor.new(1, [Person.new(6), Person.new(5), Person.new(2)]),
  Floor.new(2, [Person.new(4)]),
  Floor.new(3, []),
  Floor.new(4, [Person.new(0), Person.new(0), Person.new(0)]),
  Floor.new(5, []),
  Floor.new(6, []),
  Floor.new(7, [Person.new(3), Person.new(6), Person.new(4), Person.new(5), Person.new(6)]),
  Floor.new(8, []),
  Floor.new(9, [Person.new(1), Person.new(10), Person.new(2)]),
  Floor.new(10, [Person.new(1), Person.new(4), Person.new(3), Person.new(2)])
]
commander = Commander.new(floors)
elevator = Elevator.new(4, commander)

elevator.move

return 0
