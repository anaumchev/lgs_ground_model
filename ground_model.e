note
	description: "Summary description for {GROUND_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUND_MODEL
create run

feature

	is_handle_up: INTEGER = 0

	is_handle_down: INTEGER = 1

	is_door_closed: INTEGER = 0

	is_door_opening: INTEGER = 1

	is_door_open: INTEGER = 2

	is_door_closing: INTEGER = 3

	is_gear_retracted: INTEGER = 0

	is_gear_extending: INTEGER = 1

	is_gear_extended: INTEGER = 2

	is_gear_retracting: INTEGER = 3

feature

	handle_status: INTEGER
		do
			from
				Result := -1
			until
				Result = is_handle_up or Result = is_handle_down
			loop
				print ("handle status: ")
				io.read_integer
				io.new_line
				Result := io.last_integer
			end
		end

	door_status: INTEGER assign set_door_status

	set_door_status (new_door_status: INTEGER)
		do
			door_status := new_door_status
			print ("door status: " + new_door_status.out)
			io.new_line
		end

	gear_status: INTEGER assign set_gear_status

	set_gear_status (new_gear_status: INTEGER)
		do
			gear_status := new_gear_status
			print ("gear status: " + new_gear_status.out)
			io.new_line
		end




	close_door
		do
			inspect door_status
			when is_door_open then
				Current.door_status := is_door_closing
			when is_door_closing then
				Current.door_status := is_door_closed
			when is_door_opening then
				Current.door_status := is_door_closing
			else
			end
		end

	open_door
		do
			inspect door_status
			when is_door_closed then
				Current.door_status := is_door_opening
			when is_door_closing then
				Current.door_status := is_door_opening
			when is_door_opening then
				Current.door_status := is_door_open
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
						Current.gear_status := is_gear_retracting
					when is_gear_retracting then
						Current.gear_status := is_gear_retracted
					when is_gear_extending then
						Current.gear_status := is_gear_retracting
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
						Current.gear_status := is_gear_extending
					when is_gear_extending then
						Current.gear_status := is_gear_extended
					when is_gear_retracting then
						Current.gear_status := is_gear_extending
					else
					end
				end
			else
				close_door
			end
		end

	run
		do
			Current.door_status := is_door_closed
			Current.gear_status := is_gear_extended

			from
			until
				False
			loop
				if handle_status = is_handle_up then
					retract
				elseif handle_status = is_handle_down then
					extend
				end
			end
		end

invariant
	(gear_status = is_gear_extending or gear_status = is_gear_retracting) implies door_status = is_door_open
	door_status = is_door_closed implies (gear_status = is_gear_extended or gear_status = is_gear_retracted)
end
