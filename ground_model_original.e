note explicit: "all" -- Ignore (verification-related annotations)

class GROUND_MODEL_ORIGINAL
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

feature {NONE} -- Operations on gears

  retract
  -- Gears retraction.
    do
    -- Ignore (verification-related annotations)
      check assume:observers.is_empty end
      check assume:is_open end
    -- Meaningful instructions
      if gear_status /= is_gear_retracted then
        inspect door_status
        when is_door_closed then
          door_status := is_door_opening
        when is_door_closing then
          door_status := is_door_opening
        when is_door_opening then
          door_status := is_door_open
        else
        end
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
        inspect door_status
        when is_door_closed then
          door_status := is_door_opening
        when is_door_opening then
          door_status := is_door_open
        else
        end
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

  r11_bis
  -- If (is_normal_mode and (handle_status = is_handle_down)) hold and remain,
  -- ((gear_status = is_gear_extended) and (door_status = is_door_closed)) will hold within 10 steps.
    local
      steps: NATURAL
    do
      if (is_normal_mode and (handle_status = is_handle_down)) then
        from
          steps := 0
        until
          (not (is_normal_mode and (handle_status = is_handle_down))) or
          ((gear_status = is_gear_extended) and (door_status = is_door_closed)) or
          (steps=10)
        loop
          main
          steps := steps + 1
        end
        check
          (not (is_normal_mode and (handle_status = is_handle_down))) or
          ((gear_status = is_gear_extended) and (door_status = is_door_closed))
        end
      end
    end

  r12_bis
  -- If (is_normal_mode and (handle_status = is_handle_up)) hold and remain,
  -- ((gear_status = is_gear_retracted) and (door_status = is_door_closed)) will hold within 10 steps.
    local
      steps: NATURAL
    do
      if (is_normal_mode and (handle_status = is_handle_up)) then
        from
          steps := 0
        until
          (not (is_normal_mode and (handle_status = is_handle_up))) or
          ((gear_status = is_gear_retracted) and (door_status = is_door_closed)) or
          (steps=10)
        loop
          main
          steps := steps + 1
        end
        check
          (not (is_normal_mode and (handle_status = is_handle_up))) or
          ((gear_status = is_gear_retracted) and (door_status = is_door_closed))
        end
      end
    end

  r21
  -- If (is_normal_mode and (handle_status = is_handle_up)) holds and remains,
  -- (gear_status /= is_gear_extending) will hold within 1 step.
    local
      steps: NATURAL
    do
      if (is_normal_mode and (handle_status = is_handle_up)) then
        from
          steps := 0
        until
          (not (is_normal_mode and (handle_status = is_handle_up))) or
          (gear_status /= is_gear_extending) or
          (steps = 1)
        loop
          main
          steps := steps + 1
        end
        check
          (not (is_normal_mode and (handle_status = is_handle_up))) or
          (gear_status /= is_gear_extending)
        end
      end
    end

  r22
  -- If (is_normal_mode and (handle_status = is_handle_down)) holds and remains,
  -- (gear_status /= is_gear_retracting) will hold within 1 step.
    local
      steps: NATURAL
    do
      if (is_normal_mode and (handle_status = is_handle_down)) then
        from
          steps := 0
        until
          (not (is_normal_mode and (handle_status = is_handle_down))) or
          (gear_status /= is_gear_retracting) or
          (steps = 1)
        loop
          main
          steps := steps + 1
        end
        check
          (not (is_normal_mode and (handle_status = is_handle_down))) or
          (gear_status /= is_gear_retracting)
        end
      end
    end

  r11_rs
  -- ((gear_status = is_gear_extended) and (door_status = is_door_closed)) keeps holding under
  -- (is_normal_mode and (handle_status = is_handle_down))
    do
      if ((is_normal_mode and (handle_status = is_handle_down)) and
           ((gear_status = is_gear_extended) and (door_status = is_door_closed))) then
        main
        check
          ((is_normal_mode and (handle_status = is_handle_down)) implies
            ((gear_status = is_gear_extended) and (door_status = is_door_closed)))
        end
      end
    end

  r12_rs
  -- ((gear_status = is_gear_retracted) and (door_status = is_door_closed)) keeps holding under
  -- (is_normal_mode and (handle_status = is_handle_up))
    do
      if ((is_normal_mode and (handle_status = is_handle_up)) and
           ((gear_status = is_gear_retracted) and (door_status = is_door_closed))) then
        main
        check
          ((is_normal_mode and (handle_status = is_handle_up)) implies
            ((gear_status = is_gear_retracted) and (door_status = is_door_closed)))
        end
      end
    end

invariant
-- Ignore (verification-related annotations)
  subjects = []  
end
