# frozen_string_literal: true

require_relative 'elevator'
require_relative 'floor'
require_relative 'person'
require_relative 'commander'

commander = Commander.new(11)
floors = [
  Floor.new(0, commander, []),
  Floor.new(1, commander, [Person.new(6), Person.new(5), Person.new(2)]),
  Floor.new(2, commander, [Person.new(4)]),
  Floor.new(3, commander, []),
  Floor.new(4, commander, [Person.new(0), Person.new(0), Person.new(0)]),
  Floor.new(5, commander, []),
  Floor.new(6, commander, []),
  Floor.new(7, commander, [Person.new(3), Person.new(6), Person.new(4), Person.new(5), Person.new(6)]),
  Floor.new(8, commander, []),
  Floor.new(9, commander, [Person.new(1), Person.new(10), Person.new(2)]),
  Floor.new(10, commander, [Person.new(1), Person.new(4), Person.new(3), Person.new(2)])
]
elevator = Elevator.new(4, commander, floors)

elevator.move

return 0
