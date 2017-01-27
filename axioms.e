note
	description: "Summary description for {AXIOMS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	explicit: wrapping

deferred class
	AXIOMS

feature

	handle_status (lgs: LANDING_GEAR_SYSTEM)
		do
		ensure
			lgs.is_handle_down xor lgs.is_handle_up
		end

		-------------------------------------------------------------------

	door_status (d: DOOR)
		do
		ensure
			d.is_closed xor d.is_open
		end

		-------------------------------------------------------------------

	gear_status (g: GEAR)
		do
		ensure
			g.is_retracted xor g.is_extended
		end

		-------------------------------------------------------------------
		-------------------------------------------------------------------

	r_open_door (d: DOOR)
		do
			d.open
		ensure
			d.is_open
		end

	r_close_door (d: DOOR)
		do
			d.close
		ensure
			d.is_closed
		end

		-------------------------------------------------------------------

	r_retract_gear (g: GEAR)
		do
			g.retract
		ensure
			g.is_retracted
		end

	r_extend_gear (g: GEAR)
		do
			g.extend
		ensure
			g.is_extended
		end

		-------------------------------------------------------------------

	r_handle_up (lgs: LANDING_GEAR_SYSTEM)
		do
			lgs.handle_up
		ensure
			lgs.is_handle_up
		end

	r_handle_down (lgs: LANDING_GEAR_SYSTEM)
		do
			lgs.handle_down
		ensure
			lgs.is_handle_down
		end

		-------------------------------------------------------------------
		-------------------------------------------------------------------

	r11_bis (lgs: LANDING_GEAR_SYSTEM)
		do
			lgs.handle_down
		ensure
			lgs.gears.is_extended
			lgs.doors.is_closed
		end

	r12_bis (lgs: LANDING_GEAR_SYSTEM)
		do
			lgs.handle_up
		ensure
			lgs.gears.is_retracted
			lgs.doors.is_closed
		end

end
