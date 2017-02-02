note
	description: "Summary description for {GROUND_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
  explicit: contracts
class
	GROUND_MODEL
feature -- Constants

  -- Handle constants

	is_handle_up: INTEGER = 0

	is_handle_down: INTEGER = 1

  --Door constants

	is_door_closed: INTEGER = 0

	is_door_opening: INTEGER = 1

	is_door_open: INTEGER = 2

	is_door_closing: INTEGER = 3

  -- Gear constants

	is_gear_retracting: INTEGER = 3

	is_gear_retracted: INTEGER = 2

	is_gear_extending: INTEGER = 1

	is_gear_extended: INTEGER = 0

feature

	handle_status: INTEGER

	door_status: INTEGER

	gear_status: INTEGER

  values_are_in_ranges: BOOLEAN
    note status: functional
    do
      Result :=
        (handle_status = is_handle_up or handle_status = is_handle_down) and
        (door_status = is_door_closed or door_status = is_door_opening or door_status = is_door_open or door_status = is_door_closing) and
        (gear_status = is_gear_extended or gear_status = is_gear_extending or gear_status = is_gear_retracted or gear_status = is_gear_retracting)
    end

  set_door_status (new_door_status: INTEGER)
      -- We do not know yet how this happens, but we know the effects
    note status: skip
    require modify_field ("door_status", Current)
    do
    ensure door_status = new_door_status
    end

  set_gear_status (new_gear_status: INTEGER)
      -- We do not know how this happens, but we know the effects
    note status: skip
    require modify_field ("gear_status", Current)
    do
    ensure gear_status = new_gear_status
    end

feature {NONE}

	close_door
      -- Implementation of the r_closeDoor sequence
		do
			inspect door_status
			when is_door_open then
				set_door_status (is_door_closing)
			when is_door_closing then
				set_door_status (is_door_closed)
			when is_door_opening then
				set_door_status (is_door_closing)
			else
			end
		end

	open_door
      -- Added the lacking procedure for opening the doors
		do
			inspect door_status
			when is_door_closed then
				set_door_status (is_door_opening)
			when is_door_closing then
				set_door_status (is_door_opening)
			when is_door_opening then
				set_door_status (is_door_open)
			else
			end
		end

	retract
      -- Implementation of r_retractionSequence
		do
			if gear_status /= is_gear_retracted then
				open_door
				if door_status = is_door_open then
					inspect gear_status
					when is_gear_extended then
						set_gear_status (is_gear_retracting)
					when is_gear_retracting then
						set_gear_status (is_gear_retracted)
					when is_gear_extending then
						set_gear_status (is_gear_retracting)
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
			if gear_status /= is_gear_extended then
				open_door
				if door_status = is_door_open then
					inspect gear_status
					when is_gear_retracted then
						set_gear_status (is_gear_extending)
					when is_gear_extending then
						set_gear_status (is_gear_extended)
					when is_gear_retracting then
						set_gear_status (is_gear_extending)
					else
					end
				end
			else
				close_door
			end
		end

feature

	main
    note explicit: wrapping
		do
			if handle_status = is_handle_up then
				retract
			elseif handle_status = is_handle_down then
				extend
			end
		end


	r11_bis (steps: INTEGER)
    note explicit: wrapping
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
    	gear_status = is_gear_extended
      door_status = is_door_closed
		end

	r11_bis_inductive_step
    note explicit: wrapping
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
  

end
