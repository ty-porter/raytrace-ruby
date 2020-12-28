# frozen_string_literal: true

require_relative 'hittable'

# Representation of the world to render
#
# Simply a wrapper to HittableList, better to call:
#
# world = World.new
#
# than:
#
# world = HittableList.new
class World < HittableList
end
