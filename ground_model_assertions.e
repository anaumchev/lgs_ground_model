note explicit: "all" -- Ignore (verification-related annotations)

class GROUND_MODEL_ASSERTIONS
feature {NONE} -- State ranges

-- Handle state range
  up_position: NATURAL = 0
  down_position: NATURAL = 1

-- Door state range
  closed_position: NATURAL = 2
  opening_state: NATURAL = 3
  open_position: NATURAL = 4
  closing_state: NATURAL = 5

-- Gear state range
  retracting_state: NATURAL = 6
  retracted_position: NATURAL = 7
  extending_state: NATURAL = 8
  extended_position: NATURAL = 9

feature {NONE} -- State space

  handle_status: NATURAL
  door_status: NATURAL
  gear_status: NATURAL

feature {NONE} -- Consistency criteria

  system_executes_normally: BOOLEAN
  -- There is no "|" notation in Eiffel, thus have to check the ranges explicitly
    note status: functional
    do
      Result := ((handle_status = up_position or handle_status = down_position) and
        (door_status = closed_position or door_status = opening_state or door_status = open_position or door_status = closing_state) and
        (gear_status = extended_position or gear_status = extending_state or gear_status = retracted_position or gear_status = retracting_state) and
        ((gear_status = extending_state or gear_status = retracting_state) implies door_status = open_position) and
        (door_status = closed_position implies (gear_status = extended_position or gear_status = retracted_position)))
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
      when open_position then
        door_status := closing_state
      when closing_state then
        door_status := closed_position
      when opening_state then
        door_status := closing_state
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
      when closed_position then
        door_status := opening_state
      when closing_state then
        door_status := opening_state
      when opening_state then
        door_status := open_position
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
      if gear_status /= retracted_position then
        open_door
        if door_status = open_position then
          inspect gear_status
          when extended_position then
            gear_status := retracting_state
          when retracting_state then
            gear_status := retracted_position
          when extending_state then
            gear_status := retracting_state
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
      if gear_status /= extended_position then
        open_door
        if door_status = open_position then
          inspect gear_status
          when retracted_position then
            gear_status := extending_state
          when extending_state then
            gear_status := extended_position
          when retracting_state then
            gear_status := extending_state
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
      if handle_status = up_position then
        retract
      elseif handle_status = down_position then
        extend
      end
    end

feature {NONE} -- Requirements programming

  -- Assume an axiomatically defined function
  time_delta: INTEGER
  -- that
    do
  -- nothing
    end

  -- Assume that
  main_increments_time_delta
  -- in the following sense: given
    local
  -- variable
      old_time_delta: INTEGER
    do
  -- perform
      old_time_delta := time_delta
  -- and then
      main
  -- finally
      check assume: time_delta = old_time_delta + 1 end
    end
  
  -- Assume an invariant property saying that
  main_preserves_normal_mode
  -- in the following sense:
    do
  -- first
      check assume: system_executes_normally end
  -- assuming that
      main_increments_time_delta
  -- finally
      check assume: system_executes_normally end
    end

  -- Assume an invariant property saying that
  handle_is_up_and_stays_up
  -- in the following sense:
    do
  -- first
      check assume: handle_status = up_position end
  -- assuming that
      main_preserves_normal_mode
  -- finally
      check assume: handle_status = up_position end
    end

  -- Assume that
  handle_is_down_and_stays_down
  -- in the following sense:
    do
  -- first
      check assume: handle_status = down_position end
  -- assuming that
      main_preserves_normal_mode
  -- finally
      check assume: handle_status = down_position end
    end

  -- Require maximal distance property
  r11_bis
  -- defined as follows:
    do
      from
  -- a state that
        check assume: time_delta = 0 end
      until
  -- a state in which
        gear_status = extended_position and door_status = closed_position
  -- is reached
        or else time_delta = 10
      loop
  -- assuming that
        handle_is_down_and_stays_down
      end
  -- finally
      check assert: gear_status = extended_position end
  -- and then
      check assert: door_status = closed_position end
    end

  -- Require maximal distance property
  r12_bis
  -- defined as follows:
    do
      from
  -- a state that
        check assume: time_delta = 0 end
      until
  -- a state in which
        gear_status = retracted_position and door_status = closed_position
  -- is reached
        or else time_delta = 10
      loop
  -- assuming that
        handle_is_up_and_stays_up
      end
  -- finally
      check assert: gear_status = retracted_position end
  -- and then
      check assert: door_status = closed_position end
    end

  -- Require maximal distance property
  r21
  -- defined as follows:
    do
      from
  -- a state that
        check assume: time_delta = 0 end
      until
  -- a state in which
        gear_status /= extending_state
  -- is reached
        or else time_delta = 1
      loop
  -- assuming that
        handle_is_up_and_stays_up
      end
  -- finally
      check assert: gear_status /= extending_state end
    end

  -- Require maximal distance property
  r22
  -- defined as follows:
    do
      from
  -- a state that
        check assume: time_delta = 0 end
      until
  -- a state in which
        gear_status /= retracting_state
  -- is reached
        or else time_delta = 1
      loop
  -- assuming that
        handle_is_down_and_stays_down
      end
  -- finally
      check assert: gear_status /= retracting_state end
    end

  -- Require invariant property
  r11_rs
  -- defined as follows:
    do
  -- first
      check assume: gear_status = extended_position end
  -- and then
      check assume: door_status = closed_position end
  -- assuming that
      handle_is_down_and_stays_down
  -- finally
      check assert: gear_status = extended_position end
  -- and then
      check assert: door_status = closed_position end
    end

  --Require invariant property
  r12_rs
  -- defined as follows:
    do
  -- first
      check assume: gear_status = retracted_position end
  -- and then
      check assume: door_status = closed_position end
  -- assuming that
      handle_is_up_and_stays_up
  -- finally
      check assert: gear_status = retracted_position end
  -- and then
      check assert: door_status = closed_position end
    end

invariant
-- Ignore (verification-related annotations)
  subjects = []  
end
