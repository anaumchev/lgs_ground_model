note
	description: "Summary description for {AXIOMS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	explicit: wrapping

deferred class
	AXIOMS
feature

	handle_status_enum (gm: GROUND_MODEL)
		require
			gm.handle_status /= gm.is_handle_down
			gm.handle_status /= gm.is_handle_up
		do
		ensure
			False
		end

	door_status_enum (gm: GROUND_MODEL)
		require
			gm.door_status /= gm.is_door_closed
			gm.door_status /= gm.is_door_closing
			gm.door_status /= gm.is_door_open
			gm.door_status /= gm.is_door_opening
		do
		ensure
			False
		end

	gear_status_enum (gm: GROUND_MODEL)
		require
			gm.gear_status /= gm.is_gear_extended
			gm.gear_status /= gm.is_gear_extending
			gm.gear_status /= gm.is_gear_retracted
			gm.gear_status /= gm.is_gear_retracting
		do
		ensure
			False
		end

	gears_extend_only_with_door_open (gm: GROUND_MODEL)
		require
			gm.gear_status = gm.is_gear_extending
		do
		ensure
			gm.door_status = gm.is_door_open
		end

	gears_retract_only_with_door_open (gm: GROUND_MODEL)
		require
			gm.gear_status = gm.is_gear_retracting
		do
		ensure
			gm.door_status = gm.is_door_open
		end

	door_is_closed_only_with_gears_extended_or_retracted (gm: GROUND_MODEL)
		require
			gm.gear_status /= gm.is_gear_extended
			gm.gear_status /= gm.is_gear_retracted
		do
		ensure
			gm.door_status /= gm.is_door_closed
		end


	handle_up_door_closed_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_retracted
		end

	handle_up_door_closed_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_extended
		end



	handle_up_door_opening_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_retracted
		end

	handle_up_door_opening_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extended
		end

	handle_up_door_open_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_retracted
		end


	handle_up_door_open_gear_extending (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extending
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracting
		end

	handle_up_door_open_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracting
		end

	handle_up_door_open_gear_retracting (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracting
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracted
		end

	handle_up_door_closing_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_retracted
		end

	handle_up_door_closing_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_up
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_extended
		end


	handle_down_door_closed_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_retracted
		end

	handle_down_door_closed_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_extended
		end


	handle_down_door_opening_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracted
		end

	handle_down_door_opening_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_extended
		end

	handle_down_door_open_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extending
		end

	handle_down_door_open_gear_extending (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extending
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extended
		end

	handle_down_door_open_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_extended
		end

	handle_down_door_open_gear_retracting (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_retracting
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_open
			gm.gear_status = gm.is_gear_extending
		end

	handle_down_door_closing_gear_retracted (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_retracted
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_opening
			gm.gear_status = gm.is_gear_retracted
		end

	handle_down_door_closing_gear_extended (gm: GROUND_MODEL)
		require
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closing
			gm.gear_status = gm.is_gear_extended
		do
			gm.main
		ensure
			gm.handle_status = gm.is_handle_down
			gm.door_status = gm.is_door_closed
			gm.gear_status = gm.is_gear_extended
		end

	well_definedness (gm_1, gm_2: GROUND_MODEL)
		require
			gm_1.handle_status = gm_2.handle_status
			gm_1.door_status = gm_2.door_status
			gm_1.gear_status = gm_2.gear_status
		do
			gm_1.main
			gm_2.main
		ensure
			gm_1.handle_status = gm_2.handle_status
			gm_1.door_status = gm_2.door_status
			gm_1.gear_status = gm_2.gear_status
		end

end
