note explicit: "all"

class GROUND_MODEL
feature {NONE}
-- State ranges

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

  -- State space
  handle_status: NATURAL
  door_status: NATURAL
  gear_status: NATURAL


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
      else
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
      else
      end
    end


-- Operations on the gear.

  -- Gear retraction.
  retract
    do
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

  -- Gear extension.
  extend
    do
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

  -- Assume an axiomatically defined
  time_delta: INTEGER

  -- Assume that
  main_increments_time_delta
    -- in the following sense
    do
      -- perform
      main
      time_delta := time_delta + 1
    end

  -- Require invariant property saying that
  main_preserves_normal_mode
    -- in the following sense:
    do
      -- first
      check assume: handle_status = up_position or handle_status = down_position end
      check assume: door_status = closed_position or door_status = opening_state or door_status = open_position or door_status = closing_state end
      check assume: gear_status = extended_position or gear_status = extending_state or gear_status = retracted_position or gear_status = retracting_state end
      check assume: (gear_status = extending_state or gear_status = retracting_state) implies door_status = open_position end
      check assume: door_status = closed_position implies (gear_status = extended_position or gear_status = retracted_position) end
      -- after performing
      main_increments_time_delta
      -- do
      check assert: handle_status = up_position or handle_status = down_position end
      check assert: door_status = closed_position or door_status = opening_state or door_status = open_position or door_status = closing_state end
      check assert: gear_status = extended_position or gear_status = extending_state or gear_status = retracted_position or gear_status = retracting_state end
      check assert: (gear_status = extending_state or gear_status = retracting_state) implies door_status = open_position end
      check assert: door_status = closed_position implies (gear_status = extended_position or gear_status = retracted_position) end
    end

  -- Require invariant property saying that
  when_handle_is_up_it_stays_up
    -- in the following sense:
    do
      -- first
      check assume: handle_status = up_position end
      -- assuming that
      main_preserves_normal_mode
      -- finally
      check assert: handle_status = up_position end
    end

  -- Require invariant property saying that
  when_handle_is_down_it_stays_down
    -- in the following sense:
    do
      -- first
      check assume: handle_status = down_position end
      -- assuming that
      main_preserves_normal_mode
      -- finally
      check assert: handle_status = down_position end
    end

  -- Require maximal distance property
  r11_bis
    -- defined as follows:
    do
      -- first
      check assume: time_delta = 0 end
      -- then starting
      from
      -- the same state
      until
        -- a state in which
        gear_status = extended_position and door_status = closed_position
        -- is reached
        or else time_delta = 10
      loop
        -- assuming that
        when_handle_is_down_it_stays_down
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
      -- first
      check assume: time_delta = 0 end
      -- then starting
      from
      -- the same state
      until
        -- a state in which
        gear_status = retracted_position and door_status = closed_position
        -- is reached
        or else time_delta = 10
      loop
        -- assuming that
        when_handle_is_up_it_stays_up
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
      -- first
      check assume: time_delta = 0 end
      -- then starting
      from
      -- the same state
      until
        -- a state in which
        gear_status /= extending_state
        -- is reached
        or else time_delta = 1
      loop
        -- assuming that
        when_handle_is_up_it_stays_up
      end
      -- finally
      check assert: gear_status /= extending_state end
    end

  -- Require maximal distance property
  r22
    -- defined as follows:
    do
      -- first
      check assume: time_delta = 0 end
      -- then starting
      from
      -- the same state
      until
        -- a state in which
        gear_status /= retracting_state
        -- is reached
        or else time_delta = 1
      loop
        -- assuming that
        when_handle_is_down_it_stays_down
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
      when_handle_is_down_it_stays_down
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
      when_handle_is_up_it_stays_up
      -- finally
      check assert: gear_status = retracted_position end
      -- and then
      check assert: door_status = closed_position end
    end
end
