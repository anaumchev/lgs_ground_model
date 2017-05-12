note explicit: "all" -- Ignore (verification-related annotations)

class GROUND_MODEL_ASSERTIONS
feature {NONE} -- State ranges

-- Handle state range
  is_handle_up: NATURAL = 0
  is_handle_down: NATURAL = 1

-- Door state range
  is_door_closed: NATURAL = 2
  is_door_opening: NATURAL = 3
  is_door_open: NATURAL = 4
  is_door_closing: NATURAL = 5

-- Gear state range
  is_gear_retracting: NATURAL = 6
  is_gear_retracted: NATURAL = 7
  is_gear_extending: NATURAL = 8
  is_gear_extended: NATURAL = 9

feature {NONE} -- State space

  handle_status: NATURAL
  door_status: NATURAL
  gear_status: NATURAL

feature {NONE} -- Consistency criteria

  is_normal_mode: BOOLEAN
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

  main_preserves_normal_mode
  -- Let's assume that main preserves normal mode.
    do
      check assume: is_normal_mode end

      main

      check assume: is_normal_mode end
    end

  handle_is_up_and_stays_up
  -- Let's assume the handle is up and stays up.
    do
      check assume: handle_status = is_handle_up end

      main_preserves_normal_mode

      check assume: handle_status = is_handle_up end
    end

  handle_is_down_and_stays_down
  -- Let's assume the handle is down and stays down.
    do
      check assume: handle_status = is_handle_down end

      main_preserves_normal_mode

      check assume: handle_status = is_handle_down end
    end

  r11_bis
  -- If handle_is_down_and_stays_down,
  -- gear_status = is_gear_extended and door_status = is_door_closed will hold within 10 steps.
    local
      steps: NATURAL
    do
      from
        steps := 0
      until
        gear_status = is_gear_extended and
        door_status = is_door_closed or
        steps = 10
      loop
        handle_is_down_and_stays_down
        steps := steps + 1
      end

      check assert_extended: gear_status = is_gear_extended end
      check assert_closed: door_status = is_door_closed end
    end

  r12_bis
  -- If handle_is_up_and_stays_up
  -- gear_status = is_gear_retracted and door_status = is_door_closed will hold within 10 steps.
    local
      steps: NATURAL
    do
      from
        steps := 0
      until
        gear_status = is_gear_retracted and
        door_status = is_door_closed or
        steps=10
      loop
        handle_is_up_and_stays_up
        steps := steps + 1
      end

      check assert_retracted: gear_status = is_gear_retracted end
      check assert_closed: door_status = is_door_closed end
    end

  r21
  -- If handle_is_up_and_stays_up,
  -- (gear_status /= is_gear_extending) will hold within 1 step.
    local
      steps: NATURAL
    do
      from
        steps := 0
      until
        gear_status /= is_gear_extending or
        steps = 1
      loop
        handle_is_up_and_stays_up
        steps := steps + 1
      end

      check assert_not_extending: gear_status /= is_gear_extending end
    end

  r22
  -- If handle_is_down_and_stays_down,
  -- (gear_status /= is_gear_retracting) will hold within 1 step.
    local
      steps: NATURAL
    do
      from
        steps := 0
      until
        gear_status /= is_gear_retracting or
        steps = 1
      loop
        handle_is_down_and_stays_down
        steps := steps + 1
      end
      
      check assert_not_retracting: gear_status /= is_gear_retracting end
    end

  r11_rs
  -- If handle_is_down_and_stays_down,
  -- gear_status = is_gear_extended and door_status = is_door_closed
  -- will be a stable state.
    do
      check assume: gear_status = is_gear_extended end
      check assume: door_status = is_door_closed end

      handle_is_down_and_stays_down

      check assert_extended: gear_status = is_gear_extended end
      check assert_closed: door_status = is_door_closed end
    end

  r12_rs
  -- If handle_is_up_and_stays_up,
  -- gear_status = is_gear_retracted and door_status = is_door_closed
  -- will be a stable state.
    do
      check assume: gear_status = is_gear_retracted end
      check assume: door_status = is_door_closed end

      handle_is_up_and_stays_up

      check assert_retracted: gear_status = is_gear_retracted end
      check assert_closed: door_status = is_door_closed end
    end

invariant
-- Ignore (verification-related annotations)
  subjects = []  
end
