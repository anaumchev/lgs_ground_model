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

  is_normal_mode: BOOLEAN
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

feature {NONE} -- Representations of the requirements

  time_delta: INTEGER
    do
    end

  time_delta_grows_linearly
    local
      old_time_delta: INTEGER
    do
      old_time_delta := time_delta
      main
      check assume: time_delta = old_time_delta + 1 end
    end

  main_preserves_normal_mode
  -- Let's assume that main preserves normal mode.
    do
      check assume: is_normal_mode end
      time_delta_grows_linearly
      check assume: is_normal_mode end
    end

  handle_is_up_and_stays_up
  -- Let's assume the handle is up and stays up.
    do
      check assume: handle_status = up_position end
      main_preserves_normal_mode
      check assume: handle_status = up_position end
    end

  handle_is_down_and_stays_down
  -- Let's assume the handle is down and stays down.
    do
      check assume: handle_status = down_position end
      main_preserves_normal_mode
      check assume: handle_status = down_position end
    end

  r11_bis
  -- If handle_is_down_and_stays_down,
  -- gear_status = extended_position and door_status = closed_position will hold within 10 steps.
    do
      from
        check assume: time_delta = 0 end
      until
        gear_status = extended_position and
        door_status = closed_position or
        time_delta = 10
      loop
        handle_is_down_and_stays_down
      end
      check assert_extended: gear_status = extended_position end
      check assert_closed: door_status = closed_position end
    end

  r12_bis
  -- If handle_is_up_and_stays_up
  -- gear_status = retracted_position and door_status = closed_position will hold within 10 steps.
    do
      from
        check assume: time_delta = 0 end
      until
        gear_status = retracted_position and
        door_status = closed_position or
        time_delta = 10
      loop
        handle_is_up_and_stays_up
      end
      check assert_retracted: gear_status = retracted_position end
      check assert_closed: door_status = closed_position end
    end

  r21
  -- If handle_is_up_and_stays_up,
  -- (gear_status /= extending_state) will hold within 1 step.
    do
      from
        check assume: time_delta = 0 end
      until
        gear_status /= extending_state or
        time_delta = 1
      loop
        handle_is_up_and_stays_up
      end
      check assert_not_extending: gear_status /= extending_state end
    end

  r22
  -- If handle_is_down_and_stays_down,
  -- (gear_status /= retracting_state) will hold within 1 step.
    do
      from
        check assume: time_delta = 0 end
      until
        gear_status /= retracting_state or
        time_delta = 1
      loop
        handle_is_down_and_stays_down
      end
      check assert_not_retracting: gear_status /= retracting_state end
    end

  r11_rs
  -- If handle_is_down_and_stays_down,
  -- gear_status = extended_position and door_status = closed_position
  -- will be a stable state.
    do
      check assume: gear_status = extended_position end
      check assume: door_status = closed_position end
      handle_is_down_and_stays_down
      check assert_extended: gear_status = extended_position end
      check assert_closed: door_status = closed_position end
    end

  r12_rs
  -- If handle_is_up_and_stays_up,
  -- gear_status = retracted_position and door_status = closed_position
  -- will be a stable state.
    do
      check assume: gear_status = retracted_position end
      check assume: door_status = closed_position end
      handle_is_up_and_stays_up
      check assert_retracted: gear_status = retracted_position end
      check assert_closed: door_status = closed_position end
    end

invariant
-- Ignore (verification-related annotations)
  subjects = []  
end
