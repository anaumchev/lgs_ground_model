note
	description: "Summary description for {GROUND_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
  explicit: contracts
class
	GROUND_MODEL

feature {NONE}

	main
		do
			if handle_status = is_handle_up then
				retract
			elseif handle_status = is_handle_down then
				extend
			end
		end

	close_door
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


	is_handle_up: INTEGER = 0

	is_handle_down: INTEGER = 1

	is_door_closed: INTEGER = 0

	is_door_opening: INTEGER = 1

	is_door_open: INTEGER = 2

	is_door_closing: INTEGER = 3

	is_gear_retracting: INTEGER = 3

	is_gear_retracted: INTEGER = 2

	is_gear_extending: INTEGER = 1

	is_gear_extended: INTEGER = 0


	handle_status: INTEGER

  set_handle_status (new_handle_status: INTEGER)
    note
      status: skip
    require
      modify_field ("handle_status", Current)
    do
      handle_status := new_handle_status
    ensure
      handle_status = new_handle_status
    end

	door_status: INTEGER

  set_door_status (new_door_status: INTEGER)
    note
      status: skip
    require
      modify_field ("door_status", Current)
    do
      door_status := new_door_status
    ensure
      door_status = new_door_status
    end

	gear_status: INTEGER

  set_gear_status (new_gear_status: INTEGER)
    note
      status: skip
    require
      modify_field ("gear_status", Current)
    do
      gear_status := new_gear_status
    ensure
      gear_status = new_gear_status
    end

	r11_bis (steps: INTEGER)
    require
      steps = 5
      handle_status = is_handle_down;
      door_status = is_door_closed or door_status = is_door_closing or door_status = is_door_open or door_status = is_door_opening
      gear_status = is_gear_retracted or gear_status = is_gear_retracting or gear_status = is_gear_extended or gear_status = is_gear_extending
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
