note
  description: "Verified implementation of the Landing Gear System ASM"
  author: "Alexandr Naumchev a.naumchev at innopolis.ru"
  date: "2/2/2017"
  revision: "$1$"
  explicit: wrapping
class
  GROUND_MODEL
feature

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

feature

  handle_status: INTEGER

  door_status: INTEGER

  gear_status: INTEGER


feature -- The top-level logic

  main
      -- Implementation of r_Main
    do
    ensure
    	handle_status = old handle_status

			handle_status = is_handle_up implies (
				(old gear_status /= is_gear_retracted implies (
					(old door_status /= is_door_open implies gear_status = old gear_status) and
					(old door_status = is_door_closed implies door_status = is_door_opening) and
					(old door_status = is_door_closing implies door_status = is_door_opening) and
					(old door_status = is_door_opening implies door_status = is_door_open) and
					(old door_status = is_door_open implies (
						(old gear_status = is_gear_extended implies gear_status = is_gear_retracting) and
						(old gear_status = is_gear_retracting implies gear_status = is_gear_retracted) and
						(old gear_status = is_gear_extending implies gear_status = is_gear_retracting)
					))
				)) and
				(old gear_status = is_gear_retracted implies (
					(gear_status = old gear_status) and
					(old door_status = is_door_open implies door_status = is_door_closing) and
					(old door_status = is_door_closing implies door_status = is_door_closed) and
					(old door_status = is_door_opening implies door_status = is_door_closing)
				))
			)

			handle_status = is_handle_down implies (
				(old gear_status /= is_gear_extended implies (
					(old door_status /= is_door_open implies gear_status = old gear_status) and
					(old door_status = is_door_closed implies door_status = is_door_opening) and
--					(old door_status = is_door_closing implies door_status = is_door_opening) and
					(old door_status = is_door_opening implies door_status = is_door_open) and
					(old door_status = is_door_open implies (
						(old gear_status = is_gear_retracted implies gear_status = is_gear_extending) and
						(old gear_status = is_gear_extending implies gear_status = is_gear_extended) and
						(old gear_status = is_gear_retracting implies gear_status = is_gear_extending)
					))
				)) and
				(old gear_status = is_gear_extended implies (
					(gear_status = old gear_status) and
					(old door_status = is_door_open implies door_status = is_door_closing) and
					(old door_status = is_door_closing implies door_status = is_door_closed) and
					(old door_status = is_door_opening implies door_status = is_door_closing)
				))
			)
    end


feature {NONE}

  r11_bis (steps: INTEGER)
      -- Representation of the r11_bis requirement; we find a number of steps after which the desirable state is achieved.
      -- In this particular example, the state is achieved after 5 iterations at most.
    require
      handle_status = is_handle_down
      steps = 5
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
    do
      main
      main
    ensure
      gear_status /= is_gear_extending
    end
invariant
	handle_status = is_handle_up or handle_status = is_handle_down
	door_status = is_door_closed or door_status = is_door_opening or door_status = is_door_open or door_status = is_door_closing
	gear_status = is_gear_extended or gear_status = is_gear_extending or gear_status = is_gear_retracted or gear_status = is_gear_retracting

  gears_extend_only_with_door_open: gear_status = is_gear_extending implies door_status = is_door_open
  gears_retract_only_with_door_open: gear_status = is_gear_retracting implies door_status = is_door_open
end
