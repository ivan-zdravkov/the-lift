FLOOR_SIZE = 25
ELEVATOR_SIZE = 2
PERSON_START_INDEX = 4
WALL = '|'
TILE = '-'
BASEMENT_TILE = '='
EMPTY = ' '

# The Drawer will draw floors
class Drawer
  def initialize(floors)
    @floors = floors
  end

  def draw
    puts
    puts draw_ceiling
    @floors.reverse.each do |floor|
      puts draw_floor(floor)
      puts draw_slab unless @floors.first == floor
    end
    puts draw_basement
    puts
  end

  private

  def draw_people(floor_to_draw, index, people)
    people.each do |person|
      person_to_draw = person.destination_floor.to_s
      person_to_draw << ', ' unless people.last == person

      person_to_draw.length.times do |i|
        floor_to_draw[index] = person_to_draw[i]

        index += 1
      end
    end

    floor_to_draw
  end

  def put_people_in(floor_to_draw, waiting, arrived)
    arrived_start_index = PERSON_START_INDEX
    waiting_start_index = PERSON_START_INDEX + FLOOR_SIZE + 2 + ELEVATOR_SIZE

    floor_to_draw = draw_people(floor_to_draw, arrived_start_index, arrived)
    floor_to_draw = draw_people(floor_to_draw, waiting_start_index, waiting)

    floor_to_draw
  end

  def draw_part_of_floor(symbol, num)
    part = num.nil? ? '  ' : num.to_s
    part << EMPTY if part.length == 1
    part << WALL
    FLOOR_SIZE.times { part << symbol }
    part << WALL
    ELEVATOR_SIZE.times { part << EMPTY }
    part << WALL
    FLOOR_SIZE.times { part << symbol }
    part << WALL
    part
  end

  def draw_floor(floor)
    floor_to_draw = draw_part_of_floor(EMPTY, floor.number)
    floor_to_draw = put_people_in(floor_to_draw, floor.waiting, floor.arrived)
    floor_to_draw
  end

  def draw_slab
    draw_part_of_floor(TILE, nil)
  end

  def draw_basement
    length = FLOOR_SIZE * 2 + ELEVATOR_SIZE + 2
    basement = '  '
    basement << WALL
    length.times { basement << BASEMENT_TILE }
    basement << WALL
    basement
  end

  def draw_ceiling
    draw_basement
  end
end
