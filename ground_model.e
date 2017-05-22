note explicit: "all"

class GROUND_MODEL
feature {NONE}
-- State ranges

  -- Handle state range
  up_position: INTEGER = 0
  down_position: INTEGER = 1

  -- Door state range
  closed_position: INTEGER = 2
  opening_state: INTEGER = 3
  open_position: INTEGER = 4
  closing_state: INTEGER = 5

  -- Gear state range
  retracting_state: INTEGER = 6
  retracted_position: INTEGER = 7
  extending_state: INTEGER = 8
  extended_position: INTEGER = 9

  -- State space
  handle_status: INTEGER
  door_status: INTEGER
  gear_status: INTEGER


-- Operations on the door

  -- Closing the door.
  close_door
    do
      inspect door_status
      when open_position then
        door_status := closing_state
      when closing_state then
        door_status := closed_position
      when opening_state then
        door_status := closing_state
      end
    end

  -- Opening the door.
  open_door
    do
      inspect door_status
      when closed_position then
        door_status := opening_state
      when closing_state then
        door_status := opening_state
      when opening_state then
        door_status := open_position
      end
    end


-- Operations on the gear.

  -- Retracting the gear.
  retract_gear
    do
      inspect gear_status
      when extended_position then
        gear_status := retracting_state
      when retracting_state then
        gear_status := retracted_position
      when extending_state then
        gear_status := retracting_state
      end      
    end

  -- Extending the gear.
  extend_gear
    do
      inspect gear_status
      when retracted_position then
        gear_status := extending_state
      when extending_state then
        gear_status := extended_position
      when retracting_state then
        gear_status := extending_state
      end
    end


  -- Retraction logic.
  retract
    do
      if gear_status /= retracted_position then
        if door_status /= open_position then
          open_door
        else
          retract_gear
        end
      else
        close_door
      end
    end

  -- Extension logic.
  extend
    do
      if gear_status /= extended_position then
        if door_status /= open_position then
          open_door
        else
          extend_gear
        end
      else
        close_door
      end
    end

feature
-- The top-level logic 

  -- The main routine that will infinitely react to the handle changes.
  main
    do
      if handle_status = up_position then
        retract
      elseif handle_status = down_position then
        extend
      end
    end


-- Requirements
feature {NONE}

  -- Assume the system is
  run_in_normal_mode
    do
      check assume:
        (handle_status = up_position or handle_status = down_position) and
        (door_status = closed_position or door_status = opening_state or door_status = open_position or door_status = closing_state) and
        (gear_status = extended_position or gear_status = extending_state or gear_status = retracted_position or gear_status = retracting_state) and
        ((gear_status = extending_state or gear_status = retracting_state) implies door_status = open_position) and
        (door_status = closed_position implies (gear_status = extended_position or gear_status = retracted_position))
      end
      main
    end

  -- Assume an axiomatically defined
  distance: INTEGER

  -- Assume it takes 8 time units
  -- to take the door
  from_open_to_closed
  -- position:
    -- consider
    local
      -- variable:
      old_door_status: INTEGER      
    do
      -- that stores initial door status:
      old_door_status := door_status
      run_in_normal_mode
      -- changing the door status to 'closed_position':
      if (old_door_status /= closed_position and door_status = closed_position) then
        -- takes up to 8 time units:
        distance := distance + 8
      end
    end

  -- Assume it takes 12 time units
  -- to take the door
  from_closed_to_open
  -- position:
    -- consider
    local
      -- variable:
      old_door_status: INTEGER
    do
      -- that stores initial door status:
      old_door_status := door_status
      from_open_to_closed
      -- changing the door status to 'open_position':
      if (old_door_status /= open_position and door_status = open_position) then
        -- takes up to 12 time units:
        distance := distance + 12
      end
    end

  -- Assume it takes 10 time units
  -- to take the gear
  from_extended_to_retracted
  -- position:
    -- consider
    local
      -- variable:
      old_gear_status: INTEGER
    do
      -- that stores initial gear status:
      old_gear_status := gear_status
      from_closed_to_open
      -- changing the gear status to 'retracted_position':
      if (old_gear_status /= retracted_position and gear_status = retracted_position) then
        -- takes up to 10 time units:
        distance := distance + 10
      end
    end

  -- Assume it takes 5 time units
  -- to take the gear
  from_retracted_to_extended
  -- position:
    -- consider
    local
      -- variable:
      old_gear_status: INTEGER
    do
      -- that stores initial gear status:
      old_gear_status := gear_status
      from_extended_to_retracted
      -- changing the gear status to 'extended_position':
      if (old_gear_status /= extended_position and gear_status = extended_position) then
        -- takes up to 5 time units:
        distance := distance + 5
      end
    end

  -- Assume the system is
  run_with_handle_up
    do
      check assume: handle_status = up_position end
      from_retracted_to_extended
    end

  -- Assume the system is
  run_with_handle_down
    do
      check assume: handle_status = down_position end
      from_retracted_to_extended
    end

  -- Require the system to
  never_retract_with_handle_down
    do
      run_with_handle_down
      check assert: gear_status /= retracting_state end
    end

  -- Require that
  extension_duration
  -- is never longer than
  -- 25 time units:
    local
      old_distance: INTEGER
    do
      from
        old_distance := distance
        never_retract_with_handle_down
      until
        gear_status = extended_position and
        door_status = closed_position or
        (distance - old_distance) = 25
      loop
        run_with_handle_down
      end
      check assert: gear_status = extended_position end
      check assert: door_status = closed_position end
    end


  -- Require the system to
  never_extend_with_handle_up
    do
      run_with_handle_up
      check assert: gear_status /= extending_state end
    end

  -- Require that
  retraction
  -- never takes more than
  -- 6 steps:
    local
      steps: INTEGER
    do
      from
        steps := 0
        never_extend_with_handle_up
      until
        gear_status = retracted_position and
        door_status = closed_position or
        steps = 5
      loop
        run_with_handle_up
        steps := steps + 1
      end
      check assert: gear_status = retracted_position end
      check assert: door_status = closed_position end
    end

  -- Require that
  retraction_duration
  -- is never longer than
  -- 30 time units:
    local
      old_distance: INTEGER
    do
      old_distance := distance
      retraction
      check assert: (distance - old_distance) <= 30 end
    end

  -- Require the system to have the following
  stable_state_with_handle_down
    do
      check assume: gear_status = extended_position end
      check assume: door_status = closed_position end
      run_with_handle_down
      check assert: gear_status = extended_position end
      check assert: door_status = closed_position end
    end

  -- Require the system to have the following
  stable_state_with_handle_up
    do
      check assume: gear_status = retracted_position end
      check assume: door_status = closed_position end
      run_with_handle_up
      check assert: gear_status = retracted_position end
      check assert: door_status = closed_position end
    end
end
