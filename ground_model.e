note explicit: "all" -- Ignore (verification-related annotations)

class GROUND_MODEL
feature {NONE} -- State ranges

  -- Handle state range
  is_handle_up: INTEGER = 0
  is_handle_down: INTEGER = 1

  -- Door state range
  is_door_closed: INTEGER = 2
  is_door_opening: INTEGER = 3
  is_door_open: INTEGER = 4
  is_door_closing: INTEGER = 5

  -- Gear state range
  is_gear_retracting: INTEGER = 6
  is_gear_retracted: INTEGER = 7
  is_gear_extending: INTEGER = 8
  is_gear_extended: INTEGER = 9

feature {NONE} -- State space

  handle_status: INTEGER
  door_status: INTEGER
  gear_status: INTEGER

feature {NONE} -- Consistency criteria

  is_consistent: BOOLEAN
      -- There is no "|" notation in Eiffel, thus have to check the ranges explicitly
    note status: functional
    do
      Result := ((handle_status = is_handle_up or handle_status = is_handle_down) and
                (door_status = is_door_closed or door_status = is_door_opening or door_status = is_door_open or door_status = is_door_closing) and
                (gear_status = is_gear_extended or gear_status = is_gear_extending or gear_status = is_gear_retracted or gear_status = is_gear_retracting) and
                ((gear_status = is_gear_extending or gear_status = is_gear_retracting) implies door_status = is_door_open) and
                (door_status = is_door_closed implies (gear_status = is_gear_extended or gear_status = is_gear_retracted)))
    end

feature {NONE} -- Operations on doors

  close_door
      -- Closing the doors.
    do
      -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end
      -- Meaningful instructions
      inspect door_status
      when is_door_open then
        door_status := is_door_closing
      when is_door_closing then
        door_status := is_door_closed
      when is_door_opening then
        door_status := is_door_closing
      else
      end
    end

  open_door
      -- Opening the doors.
    do
      -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end

      -- Meaningful instructions
      inspect door_status
      when is_door_closed then
        door_status := is_door_opening
      when is_door_closing then
        door_status := is_door_opening
      when is_door_opening then
        door_status := is_door_open
      else
      end
    end

feature {NONE} -- Operations on gears

  retract
      -- Gears retraction.
    do
      -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end

      -- Meaningful instructions
      if gear_status /= is_gear_retracted then
        open_door
        if door_status = is_door_open then
          inspect gear_status
          when is_gear_extended then
            gear_status := is_gear_retracting
          when is_gear_retracting then
            gear_status := is_gear_retracted
          when is_gear_extending then
            gear_status := is_gear_retracting
          else
          end
        end
      else
        close_door
      end
    end

  extend
      -- Gears extension.
    do
      -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end

      -- Meaningful instructions
      if gear_status /= is_gear_extended then
        open_door
        if door_status = is_door_open then
          inspect gear_status
          when is_gear_retracted then
            gear_status := is_gear_extending
          when is_gear_extending then
            gear_status := is_gear_extended
          when is_gear_retracting then
            gear_status := is_gear_extending
          else
          end
        end
      else
        close_door
      end
    end

feature -- The top-level logic 

  init
      -- Initialization of the system.
    do
      -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end

      -- Meaningful instructions
      handle_status := is_handle_down
      door_status := is_door_closed
      gear_status := is_gear_extended
    end

  main
      -- The main routine that will infinitely react to the handle changes.
    do
      -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end

      -- Meaningful instructions
      if handle_status = is_handle_up then
        retract
      elseif handle_status = is_handle_down then
        extend
      end
    end

feature {NONE} -- Representations of the requirements

  init_ensures_consistency
      -- Initialization of the system has to guarantee its consistency.
    do
      init
    ensure
      is_consistent
    end

  main_preserves_consistency
      -- The main routine has to preserve consistency.
    require
      is_consistent
    do
      main
    ensure
      is_consistent
    end

  main_cannot_control_the_handle (current_handle_status: INTEGER)
      -- The handle is only observable, not controlled.
      -- The main routine cannot change the handle status.
    require
      handle_status = current_handle_status
    do
      main
    ensure
      handle_status = current_handle_status
    end

  r11_bis
      -- If the handle is down and stays down, the doors will close and the gears extend
      -- in not more than MAX_INT steps:
      -- ag(ag(handle = DOWN) implies af[MAX_INT](gears = EXTENDED and doors = CLOSED))
    require
      is_consistent
    local
      steps: INTEGER
    do
      from
        steps := 0
      until
        (handle_status /= is_handle_down) or else
        (door_status = is_door_closed and gear_status = is_gear_extended) or else
        (steps = steps.max_value)
      loop
        main
        steps := steps + 1
      end
      check (handle_status = is_handle_down) implies (steps < steps.max_value) end
    end

  r11_bis_stability
      -- If the handle is down, the door is closed and the gear is extended,
      -- the system will maintain this state:
      -- ag(ag(handle = DOWN and doors = CLOSED and gears = EXTENDED) implies ax(ag(handle = DOWN and doors = CLOSED and gears = EXTENDED)))
    require
      handle_status = is_handle_down
      door_status = is_door_closed
      gear_status = is_gear_extended
    do
      main
    ensure
      handle_status = is_handle_down
      door_status = is_door_closed
      gear_status = is_gear_extended
    end

  r12_bis
      -- If the handle is up and stays up, the doors will close and the gears will retract
      -- in not more than MAX_INT runs of the main routine:
      -- ag(ag(handle = UP) implies af[MAX_INT](gears = RETRACTED and doors = CLOSED))
    require
      is_consistent
    local
      steps: INTEGER
    do
      from
        steps := 0
      until
        (handle_status /= is_handle_up) or else
        (door_status = is_door_closed and gear_status = is_gear_retracted) or else
        (steps = steps.max_value)
      loop
        main
        steps := steps + 1
      end

      check (handle_status = is_handle_up) implies (steps < steps.max_value) end
    end

  r12_bis_stability
      -- If the handle is up, the doors are closed and the gears are retracted,
      -- the system will maintain this state:
      -- ag(ag(handle = UP and doors = CLOSED and gears = RETRACTED) implies ax(ag(handle = UP and doors = CLOSED and gears = RETRACTED)))
    require
      handle_status = is_handle_up
      door_status = is_door_closed
      gear_status = is_gear_retracted
    do
      main
    ensure
      handle_status = is_handle_up
      door_status = is_door_closed
      gear_status = is_gear_retracted
    end

  r21
      -- If the handle is down, then in the next state
      -- the gears will not be retracting:
      -- ag(ag(handle = DOWN) implies ax(ag(gears != RETRACTING)))
    require
      handle_status = is_handle_down
      is_consistent
    do
      main
    ensure
      gear_status /= is_gear_retracting
    end

  r22
      -- If the handle is up, then in the next state
      -- the gears will not be extending:
      -- ag(ag(handle = UP) implies ax(ag(gears != EXTENDING)))
    require
      handle_status = is_handle_up
      is_consistent
    do
      main
    ensure
      gear_status /= is_gear_extending
    end

invariant
  -- Ignore (verification-related annotations)
  subjects = []  
end
