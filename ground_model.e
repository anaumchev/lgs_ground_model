note
  description: "Verified implementation of the Landing Gear System ASM"
  author: "Alexandr Naumchev a.naumchev at innopolis.ru"
  date: "2/2/2017"
  revision: "$1$"
  explicit: "all"
class
  GROUND_MODEL
feature {NONE}

  -- Handle state range
  is_handle_up: INTEGER = 0

  is_handle_down: INTEGER = 1

  -- Door state range

  is_door_closed: INTEGER = 0

  is_door_opening: INTEGER = 1

  is_door_open: INTEGER = 2

  is_door_closing: INTEGER = 3

  -- Gear state range

  is_gear_retracting: INTEGER = 3

  is_gear_retracted: INTEGER = 2

  is_gear_extending: INTEGER = 1

  is_gear_extended: INTEGER = 0

feature {NONE}

  handle_status: INTEGER

  door_status: INTEGER

  gear_status: INTEGER

  values_are_in_ranges: BOOLEAN
      -- There is no "|" notation in Eiffel, thus have to check the ranges explicitly
    note status: functional
    do
      Result :=
        (handle_status = is_handle_up or handle_status = is_handle_down) and
        (door_status = is_door_closed or door_status = is_door_opening or door_status = is_door_open or door_status = is_door_closing) and
        (gear_status = is_gear_extended or gear_status = is_gear_extending or gear_status = is_gear_retracted or gear_status = is_gear_retracting)
    end

feature {NONE} -- Operations on doors

  close_door
      -- Implementation of the r_closeDoor sequence
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
      -- Added the lacking procedure for opening the doors
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
      -- Implementation of r_retractionSequence
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
      -- Implementation of r_outgoingSequence
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

feature {NONE} -- The top-level logic 

  main
      -- Implementation of r_Main
    do
      if handle_status = is_handle_up then
        retract
      elseif handle_status = is_handle_down then
        extend
      end
    end

feature -- The entry point to the system
  
  working_loop
      -- This routine continuously polls the system's state and reacts to any changes
    do
      from
      until
        False
      loop
        main
      end
    end

feature {NONE}

  r11_bis (steps: INTEGER)
      -- Representation of the r11_bis requirement; we find a number of steps after which the desirable state is achieved.
      -- In this particular example, the state is achieved after 5 iterations at most.
    require
      handle_status = is_handle_down
      steps = 5
      values_are_in_ranges
    local
      i: INTEGER
    do
      from
        i := 0
      until
        i = steps
      loop
        main
        i := i + 1
      end
    ensure
      door_status = is_door_closed
      gear_status = is_gear_extended
    end

  r11_bis_stability
      -- We check that, once the desirable state is achieved, additional iterations will not invalidate it.
    require
      handle_status = is_handle_down
      door_status = is_door_closed
      gear_status = is_gear_extended
    do
      main
    ensure
      door_status = is_door_closed
      gear_status = is_gear_extended
    end


  r12_bis (steps: INTEGER)
      -- Representation of the r12_bis requirement; we find a number of steps after which the desirable state is achieved.
      -- In this particular example, the state is achieved after 5 iterations at most.
    require
      handle_status = is_handle_up
      steps = 5
      values_are_in_ranges
    local
      i: INTEGER
    do
      from
        i := 0
      until
        i = steps
      loop
        main
        i := i + 1
      end
    ensure
      door_status = is_door_closed
      gear_status = is_gear_retracted
    end

  r12_bis_stability
      -- We check that, once the desirable state is achieved, additional iterations will not invalidate it.
    require
      handle_status = is_handle_up
      door_status = is_door_closed
      gear_status = is_gear_retracted
    do
      main
    ensure
      door_status = is_door_closed
      gear_status = is_gear_retracted
    end

  r21
      -- Representation of r21; it fails verification: in the next state doors' status is changed first, and only after that - the gears' status.
      -- If you uncomment the second 'main' call, it will pass verification.
    require
      handle_status = is_handle_down
      values_are_in_ranges
    do
      main
--      main
    ensure
      gear_status /= is_gear_retracting
    end

  r22
      -- Representation of r22; it fails verification: in the next state doors' status is changed first, and only after that - the gears' status.
      -- If you uncomment the second 'main' call, it will pass verification.
    require
      handle_status = is_handle_up
      values_are_in_ranges
    do
      main
      main
    ensure
      gear_status /= is_gear_extending
    end

invariant
  -- Ignore (verification-related annotations)
  subjects = []  
end
