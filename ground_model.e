note
	description: "Summary description for {GROUND_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUND_MODEL

create
	run

feature

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

feature

	handle_status: INTEGER

	door_status: INTEGER

	gear_status: INTEGER

	close_door
		do
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
		do
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

	retract
		do
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
		do
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

	main
		do
			if handle_status = is_handle_up then
				retract
			elseif handle_status = is_handle_down then
				extend
			end
		end

	run
		do
			from
			until
				False
			loop
				main
			end
		end

	r11_bis (steps: INTEGER)
		require
			steps > 40
		local
			i: INTEGER
		do
			from
				i := 0
			until
				steps = i
			loop
				handle_status := is_handle_down
				main
				i := i + 1
			variant
				steps - i
			end
		ensure
			gear_status = is_gear_extended and door_status = is_door_closed
		end

end
