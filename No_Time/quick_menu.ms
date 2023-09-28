//QUICK MENU
//By: Plueres
//Version: 1.3.1
stop = function // Stop at current menu
	while true
		yield
	end while
end function
Month_Name = function(monthname)
	if monthname == "01" then
		return "Jan"
	else if monthname == "02" then
		return "Feb"
	else if monthname == "03" then
		return "Mar"
	else if monthname == "04" then
		return "Apr"
	else if monthname == "05" then
		return "May"
	else if monthname == "06" then
		return "Jun"
	else if monthname == "07" then
		return "Jul"
	else if monthname == "08" then
		return "Aug"
	else if monthname == "09" then
		return "Sep"
	else if monthname == "10" then
		return "Oct"
	else if monthname == "11" then
		return "Nov"
	else if monthname == "12" then
		return "Dec"
	end if
end function
Travel_History = function
	//Create History File
	if find ("Travel History") == -1 then
		breakline
		print "'Travel History' "
		create "Travel History"
		writeline "Travel History", 0, "Travel History:"
	end if
end function
main = function
	clear
	print "Quick Menu"
	breakline
	print "Select with numbers (1-7)"
	breakline
	print "1 - Time Travel"
	breakline
	print "2 - Space Travel"
	breakline
	print "3 - Return to the Safe House from Time Travel"
	breakline
	print "4 - Return to the Safe House from Space Travel"
	breakline
	print "5 - PLC Settings"
	breakline
	print "6 - HVD Chip Settings"
	breakline
	print "    Requires you to have this script installed on a HVD disk"
	breakline
	print "7 - Cococrab Mode"
	breakline
	mainChoice = readkey
	if mainChoice.val == 1 then
		Time_Module
	else if mainChoice.val == 2 then
		Space_Module
	else if mainChoice.val == 3 then
		recalltimegate
		wait 3
		breakline
		print "Stuck? Press any other to go back"
		dialGateBack = readkey
		main
	else if mainChoice.val == 4 then
		connectgate
		wait 2
		dialgate "xxxxx"
		wait 3
		breakline
		print "Stuck? Press any other to go back"
		dialGateBack = readkey
		main
	else if mainChoice.val == 5 then
		PLC_Settings
	else if mainChoice.val == 6 then
		Create_Chip
	else if mainChoice.val == 7 then
		Cococrab_Mode
	end if
end function
Time_Module = function
	clear
	print "Connection status: "
	connectgate
	wait 1.5 //Wait for connection
	print "You chose Time Travel"
	breakline
	print "Select with numbers (0-2)"
	breakline
	print "1 - Random Date and Time"
	breakline
	print "2 - Enter Date and Time"
	breakline
	print "  - Press any other key to go back"
	Time_Module_Choice = readkey

	if Time_Module_Choice.val == 1 then
		//Randomize Time function
		RandomTime = function(timeNumber, length=2)
			//Convert number to string
			timeString = str(timeNumber)
			//add leading 0s for every value that should have 2 characters
			while timeString.len < length
				timeString = "0" + timeString
			end while
			return timeString
		end function
		timeAddress = ""
		//year = round(rnd * (3793 + 2077) - 3793)
		year = ceil(rnd * 2077)
		// check if the year is negative
		if year < 0 then
			timeAddress = "-"
			year = year * -1
		end if
		// Add month
		Month = RandomTime(ceil(rnd * 12))
		// Add day
		Day = RandomTime(ceil(rnd * 30))
		// Add year
		Year = RandomTime(year, 4)
		// Add hour
		Hour = RandomTime(floor(rnd * 24))
		// Add minute
		Minute = RandomTime(floor(rnd * 60))
		breakline
		Overridedate_Value = Month + Day + Year + Hour + Minute;
		dialgate Overridedate_Value //start dialing the address
		Travel_History()
		writeline "Travel History", countlines("Travel History")+1, "Random Date: " + Day + " " + Month_Name(Month) + " " + Year + " " + Hour + ":" + Minute
		stop
	else if Time_Module_Choice.val == 2 then
		wrong = function 
			wait
			Time_Module
		end function
		clear
		print "Connection status: Connected"
		breakline
		print "Enter Day as Number (DD)"
		wait 0
		Day = readline
		if Day.len == 2 and Day.val <= 31 then
			clear
			print "Day: " + Day
			breakline
			print "Enter Month as Number (MM)"
			wait 0
			Month = readline
			if Month.len == 2 and Month.val <= 12 then
				clear
				print "Day: " + Day
				breakline
				print "Month: " + Month_Name(Month)
				breakline
				print "Enter Year as Number (YYYY)"
				wait 0
				Year = readline
				if Year.len == 4 and Year.val <= 2076 then
					clear
					print "Day: " + Day
					breakline
					print "Month: " + Month_Name(Month)
					breakline
					print "Year: " + Year
					breakline
					print "Enter Hour as Number (HH)"
					wait 0
					Hour = readline
					if Hour.len == 2 and Hour.val <= 24 then
						clear
						print "Date: " + Day + "/" + Month + "/" + Year + " (DD/MM/YYYY)"
						breakline
						print "Hour: " + Hour
						breakline
						print "Enter Minute as Number (MM)"
						wait 0
						Minute = readline
						if Minute.len == 2 and Minute.val <= 59 then
							yield
						else
							print "This is not a valid minute"
							wrong
						end if
					else
						print "This is not a valid hour"
						wrong
					end if
				else
					print "This is not a valid year"
					wrong
				end if
			else
				print "This is not a valid month"
				wrong
			end if
		else
			print "This is not a valid day"
			wrong
		end if
		clear
		Overridedate_Value = Month + Day + Year + Hour + Minute
		dialgate Overridedate_Value
		breakline
		print "You Entered:"
		breakline
		print "Day: " + Day
		breakline
		print "Month: " + Month_Name(Month)
		breakline
		print "Year: " + Year
		breakline
		print "Time: " + Hour + ":" + Minute
		Travel_History()
		writeline "Travel History", countlines("Travel History")+1, "Date: " + Day + " " + Month_Name(Month) + " " + Year + " " + Hour + ":" + Minute
		stop
	else
		main
end function
Space_Module = function
	clear
	print "Connection status: "
	connectgate
	wait 1.5 //Wait for connection
	print "You chose Space Travel"
	breakline
	print "Select with numbers (0-2)"
	breakline
	print "1 - Random Dialgate Code"
	breakline
	print "2 - Enter Dialgate Code"
	breakline
	print "  - Press any other key to go back"
	Space_Module_Choice = readkey
	if Space_Module_Choice.val == 1 then
		// Generate random space gate address
  		Space_Coordinate = ""
  		for i in range(1, 5)
    		Space_Coordinate = Space_Coordinate + char(rnd * 24 + 97)
  		end for
		breakline
		dialgate Space_Coordinate.upper
		Travel_History()
		writeline "Travel History", countlines("Travel History")+1, "Random Planet Code: " + Space_Coordinate.upper
	else if Space_Module_Choice.val == 2 then
		breakline
		print "Connection status: Connected"
		breakline
		print "Please enter Coordinates using 5 characters (A-X)"
		wait 0
		Space_Coordinate = readline
		if Space_Coordinate.len != 5 then // if it is not exactly 5 characters then exit
			print "Please enter the correct format"
			wait
			Space_Module
		end if
		breakline
		dialgate Space_Coordinate.upper
		Travel_History()
		writeline "Travel History", countlines("Travel History")+1, "Planet Code: " + Space_Coordinate.upper
	else
		main
	end if
	stop
end function
PLC_Settings = function 
	clear
	print "PLC settings"
	breakline
	print "1 - Timegraph"
	breakline
	print "2 - Check if you can travel to a certain year (currently not working properly)"
	breakline
	print "3 - Car Diagnostics"
	breakline
	print "  - Press any other key to go back"
	breakline
	checkTimeChoice = readkey
	if checkTimeChoice.val == 1 then
		bgcolor 0,0,0
		timegraph
		clear
		stop
	else if checkTimeChoice.val == 2 then
		print "Enter a year"
		checkTimeYearChoice = readline
		if cantravel(checkTimeYearChoice) == 1 then
			print "Yes"
			wait
			Check_Time
		else
			print "No"
			wait
			Check_Time
		end if
	else if checkTimeChoice.val == 3 then
		cardiag
		wait 3
		Check_Time
	else
		main
	end if
end function
Create_Chip = function
	clear
	print "Make sure you have this script running on a .eee file on the disk and not a file on the PLC!"
	breakline
	print "Select with numbers (0-2)"
	breakline
	breakline
	print "1 - Overridedate"
	breakline
	print "2 - Set chip label"
	breakline
	print "  - Press any other key to go back"
	wait 0
	Create_Chip_Choice = readkey
	if Create_Chip_Choice.val == 1 then 
		clear
		print "This command will create a file called startup.eee if it doesn't already exist"
		breakline
		wait 3
		Overridedate_Command
	else if Create_Chip_Choice.val == 2 then
		clear
		print "Enter a name for the HVD chip"
		breakline
		wait 0
		chipName = readline
		clear
		print "The name will be '" + chipName + "'. Is this correct? (Y)es or (N)o"
		wait 0
		chipName_Conf = readkey
		if chipName_Conf.lower == "yes" or chipName_Conf.lower == "y" then
			breakline
			print "Setting chip name to " + chipName + "..."
			wait
			breakline
			setlabel str(chipName)
			wait 2
			main
		else
			breakline
			print "Did not set the chip name to " + chipName
			wait
			Create_Chip
		end if
	else 
	main
	end if
end function
Overridedate_Command = function
	clear
	print "Do you want to go to the BC times? (Times before the year 0)"
	breakline
	print "You will be able to enter the year later."
	breakline
	print "(Y)es or (N)o"
	wait 0
	negativeChoice = readkey
	if negativeChoice == "y" then
		Negative = "-"
	else
		Negative = ""
	end if
	wrong = function 
		wait
		Overridedate_Command
	end function
	clear
	print "Enter Day as Number (DD)"
	wait 0
	Day = readline
	if Day.len == 2 and Day.val <= 31 then
		clear
		print "Day: " + Day
		breakline
		print "Enter Month as Number (MM)"
		wait 0
		Month = readline
		if Month.len == 2 and Month.val <= 12 then
			clear
			print "Day: " + Day
			breakline
			print "Month: " + Month_Name(Month)
			breakline
			print "Enter Year as Number (YYYY)"
			wait 0
			Year = readline
			if Year.len == 4 and Year.val <= 2076 then
				clear
				print "Day: " + Day
				breakline
				print "Month: " + Month_Name(Month)
				breakline
				print "Year: " + Year
				breakline
				print "Enter Hour as Number (HH)"
				wait 0
				Hour = readline
				if Hour.len == 2 and Hour.val <= 24 then
					clear
					print "Date: " + Day + "/" + Month + "/" + Year + " (DD/MM/YYYY)"
					breakline
					print "Hour: " + Hour
					breakline
					print "Enter Minute as Number (MM)"
					wait 0
					Minute = readline
					if Minute.len == 2 and Minute.val <= 59 then
						yield
					else
						print "This is not a valid minute"
						wrong
					end if
				else
					print "This is not a valid hour"
					wrong
				end if
			else
				print "This is not a valid year"
				wrong
			end if
		else
			print "This is not a valid month"
			wrong
		end if
	else
		print "This is not a valid day"
		wrong
	end if
	clear
	breakline
	print "You Entered:"
	breakline
	print "Day: " + Day
	breakline
	print "Month: " + Month_Name(Month)
	breakline
	print "Year: " + Negative + Year
	breakline
	print "Time: " + Hour + ":" + Minute
	Overridedate_Value = Day + Month + Negative + Year + Hour + Minute
	breakline
	print Overridedate_Value
	breakline
	if find ("startup.eee") != -1 then
		lines = countlines ("startup.eee")
	end if
	breakline
	Overridedate_Pos_Value = Day + Month + Year + Hour + Minute
	if Overridedate_Pos_Value.len == 12 then
		print "Checking if file exists and if it is empty"
		breakline
		wait
		if find ("startup.eee") == -1 then
			print "File doesn't exist yet, creating..."
			breakline
			create "startup.eee"
			wait 
			print "Writing..."
			wait 2
			breakline
			writeline "startup.eee", 0, "overridedate " + Overridedate_Value
			print "Done"
			wait 2
			main
		else if lines < 1 then
			print "Nothing in the file yet, writing..."
			breakline
			wait 2
			writeline "startup.eee", lines, "overridedate " + Overridedate_Value
			print "Done"
			wait 2
			main
		else
			print "startup.eee is not empty, overwriting..."
			breakline
			wait 2
			if find ("startup.eee") == -1 then
				print "startup.eee doesn't exist because of a bug, creating again..."
				create "startup.eee"
				breakline
			else 
				delete "startup.eee"
				wait //just for user experience
				create "startup.eee"
				wait //just for user experience
			end if
			writeline "startup.eee", lines, "overridedate " + Overridedate_Value
			print "Writing..."
			wait
			breakline
			print "Done"
		end if
	else
	print "ERROR: Invalid input. Aborting..."
	end if
	while true
		yield
	end while
end function
Cococrab_Mode = function
	print "Do you want to enable Cococrab Mode? (Cheats)"
	breakline
	print "(Y)es or (N)o"
	breakline
	print "WARNING: Cococrab Mode will disable Steam Achievements for the current session"
	breakline
	wait 0
	cheatsEnabled = readkey
	
	if cheatsEnabled == "y" then
		cococrab
		print "Cococrab Mode enabled"
		wait
		Cococrab_Menu
	else 
		print "Cococrab mode will not be enabled. Aborting..."
		wait
		main
	end if
end function
Cococrab_Menu = function
	clear
	print "Cococrab Mode is enabled"
	breakline
	print "To disable Cococrab mode reload the current save file"
	breakline
	print "Select with numbers (0-9)"
	breakline
	print "1 - Quick Save (Bugged and not working)"
	breakline
	print "2 - Spawn Items"
	breakline
	print "3 - Get Money"
	breakline
	print "4 - Teleport"
	breakline
	print "5 - Change Time"
	breakline
	print "6 - Player Setting"
	breakline
	print "7 - Car Settings"
	breakline
	print "9 - Next Page"
	breakline
	print "  - Press any other key to go back"
	CococrabMenuChoice = readkey

	if CococrabMenuChoice.val == 1 then
		breakline
		cocosave
		print "Saved Game"
		wait
		Cococrab_Menu
	else if CococrabMenuChoice.val == 2 then
		Spawn_Items
	else if CococrabMenuChoice.val == 3 then
		Get_Money
	else if CococrabMenuChoice.val == 4 then
		Teleport
	else if CococrabMenuChoice.val == 5 then
		Change_Time
	else if CococrabMenuChoice.val == 6 then
		Player_Settings
	else if CococrabMenuChoice.val == 7 then 
		Car_Settings
	else if CococrabMenuChoice.val == 9 then
		Cococrab_Menu2
	else 
		main
	end if
end function
Cococrab_Menu2 = function
	clear
	print "Cococrab Mode is enabled"
	breakline
	print "Page 2"
	breakline
	print "Select with numbers (0-3)"
	breakline
	print "1 - Change time speed"
	breakline
	print "2 - Get current quest name and ID (Not currently supported)"
	breakline
	print "3 - Set current quest progress (Not currently supported)"
	breakline
	print "  - Press any other key to go back"
	wait 0
	CococrabMenu2Choice = readkey

	if CococrabMenu2Choice.val == 1 then
		clear
		print "Change time speed to:"
		breakline
		print "1 - Default"
		breakline
		print "2 - 0.5x Speed"
		breakline
		print "3 - 2x Speed"
		breakline
		print "4 - 4x Speed"
		breakline
		print "5 - 10x Speed"
		breakline
		print "6 - Own input"
		breakline
		print "  - Press any other key to go back"
		wait 0
		changeTimeSpeedChoice = readkey
		breakline

		if changeTimeSpeedChoice.val == 1 then
			cocospeed 1.0
			wait
			Cococrab_Menu2
		else if changeTimeSpeedChoice.val == 2 then
			cocospeed 0.5
			wait
			Cococrab_Menu2
		else if changeTimeSpeedChoice.val == 3 then
			cocospeed 2.0
			wait
			Cococrab_Menu2
		else if changeTimeSpeedChoice.val == 4 then
			cocospeed 4.0
			wait
			Cococrab_Menu2
		else if changeTimeSpeedChoice.val == 5 then
			cocospeed 10.0
			wait
			Cococrab_Menu2
		else if changeTimeSpeedChoice.val == 6 then
			breakline
			print "Enter a value"
			breakline
			print "Values above 1,000,000 can cause severe lag. And values around 1,000,000,000,000 may freeze/crash the game. This may differ per device"
			breakline
			wait 0
			changeTimeSpeedOwnInput = readline
			cocospeed changeTimeSpeedOwnInput.val
			wait
			Cococrab_Menu2
		else
			Cococrab_Menu2
		end if
	else if CococrabMenu2Choice.val == 2 then
		breakline
		cocogetqname
		wait 
		Cococrab_Menu2
	else if CococrabMenu2Choice.val == 3 then
		clear
		print "Set the quest ID"
		wait 0
		questID = readline
		print "Set the quest to:"
		breakline
		print "1 - Accepted"
		breakline
		print "2 - Finished"
		breakline
		print "3 - Invisible"
		breakline
		print "4 - Inactive"
		breakline
		print "  - Press any other key to go back"
		breakline
		wait 0
		questStatus = readkey

		if questStatus.val == 1 then
			questStatusLabel = "accepted"
		else if questStatus.val == 2 then
			questStatusLabel = "finished"
		else if questStatus.val == 3 then
			questStatusLabel = "invisible"
		else if questStatus.val == 4 then
			questStatusLabel = "inactive"
		else
			breakline
			print "Canceled"
			wait
			Cococrab_Menu2
		end if
		cocoquest + questID + questStatusLabel
		wait
		Cococrab_Menu2
	else
		Cococrab_Menu
	end if
end function
Spawn_Items = function
	clear
	print "1 - List all items and their ID's (known to cause some lag, please be patient) (bug, cannot scroll)"
	breakline
	print "2 - Cocogive. Give yourself an item by its ID"
	breakline
	print "  - Press any other key to go back"
	wait 0
	spawnItemsChoice = readkey

	if spawnItemsChoice.val == 1 then
		clear
		cocoitems
		yield
		wait 0
	else if spawnItemsChoice.val == 2 then
		breakline
		print "Enter an item ID"
		wait 0
		itemID_Choice = readline
		cocogive itemID_Choice.val
		breakline
		print "Given the item " + itemID_Choice.val + ". Which will now be in front of you on the ground"
		wait 2
		clear
		Spawn_Items
	else
		Cococrab_Menu
	end if
end function
Get_Money = function
	clear
	print "What kind of money do you want to get?"
	breakline
	print "1 - Shillings"
	breakline
	print "2 - Dollars"
	breakline
	print "3 - Imperial Money"
	breakline
	print "4 - All"
	breakline
	print "  - Press any other key to go back"
	wait 0
	moneyKindChoice = readkey
	
	if moneyKindChoice.val == 1 then
		breakline
		print "How much money do you want to get?"
		breakline
		wait 0
		moneyAmountChoice = readline
		cocoshilling moneyAmountChoice.val	
	else if moneyKindChoice.val == 2 then
		breakline
		print "How much money do you want to get?"
		breakline
		wait 0
		moneyAmountChoice = readline
		cocodollar moneyAmountChoice.val
	else if moneyKindChoice.val == 3 then
		breakline
		print "How much money do you want to get?"
		breakline
		wait 0
		moneyAmountChoice = readline
		cocoimperial moneyAmountChoice.val
	else if moneyKindChoice.val == 4 then
		breakline
		print "How much money do you want to get?"
		breakline
		wait 0
		moneyAmountChoice = readline
		cocoshilling moneyAmountChoice.val
    	cocodollar moneyAmountChoice.val
    	cocoimperial moneyAmountChoice.val
	else
		Cococrab_Menu
	end if
end function
Teleport = function
	clear
	print "Where do you want to teleport?"
	breakline
	print "Warning: this can cause some lag"
  	breakline
  	print "1 - Start location"
	breakline
  	print "2 - Bill's garage"
  	breakline
  	print "3 - Pine City garage"
  	breakline
  	print "4 - E. R. Athor's Lab"
  	breakline	
  	print "5 - Bridgetown"
  	breakline
  	print "6 - Cape Dun"
  	breakline
  	print "7 - Cafè Skylight"
  	breakline
  	print "8 - Uroruh Peak"
  	breakline
  	print "9 - Next Page"
	breakline
	print "  - Press any other key to go back"
  	breakline
  	wait 0
  	teleportChoice = readkey
  	clear
	if teleportChoice.val == 1 then
  	  	// Default starting location by the big bridge. Car and player.
  	  	cocotransport 20, 44, -1127
  	  	cococarport 26, 42, -1128
		Cococrab_Menu
  	else if teleportChoice.val == 2 then
		//Bills garage
  		if getyear < 1940 or getyear > 2026 then
  			cocoyear 2014
  			yield
  		end if
  		cocotransport -5, 0, -125
  		cococarport -9, -2, -128 
		Cococrab_Menu
	else if teleportChoice.val == 3 then
		//Pine City garage
	    if getyear < 2045 or getyear > 2074 then
	    	cocoyear 2060
	    	yield
	    end if
	    cocotransport -10, 182, -100 
	    cococarport -16, 180, -99
		Cococrab_Menu
	else if teleportChoice.val == 4 then
	    //E. R. Athors Lab.
	    cocotransport 0,0,0
		Cococrab_Menu
	else if teleportChoice.val == 5 then
	    //Bridgetown (taxi sitting area)
	    if getyear < 2007 or getyear > 2026 then
			cocoyear 2014
		end if
	    cocotransport -55, 73, 2100
		Cococrab_Menu
	else if teleportChoice.val == 6 then
	    //Cape Dun
	    cocotransport -223, -7, 2044
		Cococrab_Menu
	else if teleportChoice.val == 7 then
	    //Just outside Caffè Skylight
	    if getyear < 2045 or getyear > 2074 then
			cocoyear 2060 
		end if	
  	  	cocotransport 225, 215, 0
		Cococrab_Menu
	else if teleportChoice.val == 8 then
  	  	//Mt. Uroruh Peak
  	  	cocotransport -20, 500, 1160
		Cococrab_Menu
  	else if teleportChoice.val == 9 then
		Teleport2
	else
  	  	Cococrab_Menu
  end if
end function
Teleport2 = function
	clear
	print "Not functional yet"
	wait
	Teleport
end function
Change_Time = function
	clear
	print "Select desired time of day"
  	breakline
	breakline
	print "1 - Own Input"
	breakline
	print "2 - Sunrise - 06:30 AM"
	breakline
	print "3 - Morning - 10:00 AM"
	breakline
	print "4 - Noon - 12:00 AM"
	breakline
	print "5 - Afternoon - 15:00 PM"
	breakline
	print "6 - Sunset - 17:40 PM"
	breakline
	print "7 - Bedtime - 19:20 PM"
	breakline
	print "8 - Midnight - 00:00 AM"
	breakline
	print "9 - Late Night/Early Morning - 03:00 AM"
	breakline
	print "  - Press any other key to go back"
	breakline
	wait 0
	changeTimeChoice = readkey

	if changeTimeChoice.val == 1 then
  	  	clear
		print "Select a number from 0-360"
		breakline
		wait 0
		changeTimeValue = readline
		cocotime changeTimeValue.val
		wait
		Change_Time
  	else if changeTimeChoice.val == 2 then
		cocotime 95
		wait
		Change_Time
	else if changeTimeChoice.val == 3 then
		cocotime 150
		wait
		Change_Time
	else if changeTimeChoice.val == 4 then
		cocotime 180
		wait
		Change_Time
	else if changeTimeChoice.val == 5 then
		cocotime 225
		wait
		Change_Time
	else if changeTimeChoice.val == 6 then
		cocotime 265
		wait
		Change_Time
	else if changeTimeChoice.val == 7 then
		cocotime 290
		wait
		Change_Time
	else if changeTimeChoice.val == 8 then
		cocotime 0
		wait
		Change_Time
	else if changeTimeChoice.val == 9 then
		cocotime 45
		wait
		Change_Time
	else
		Cococrab_Menu
	end if
end function
Player_Settings = function
	clear
	print "Player Settings"
	breakline
	print "Select with numbers (0-4)"
	breakline
	breakline
	print "1 - Heal player"
	breakline
	print "2 - Clear Radiation"
	breakline
	print "3 - Get current location (Not currently supported)"
	breakline
	print "4 - Set current location (Not currently supported)"
	breakline
	print "  - Press any other key to go back"
	wait 0
	playerSettingsChoice = readkey
	if playerSettingsChoice.val == 1 then
		breakline
		cocoheal
		print "Player Healed"
		wait 2
		Player_Settings
	else if playerSettingsChoice.val == 2 then
		breakline
		cocorads
		print "Player cleared of radiation"
		wait 2
		Player_Settings
	else if playerSettingsChoice.val == 3 then
		print "  - Press any other key to go back"
		breakline
		print "Current location is: "
		cocotransport
		curLocKey = readkey
		if curLocKey == 0 then
			return false
		end if
	else if playerSettingsChoice.val == 4 then
		print "Enter a location:"
		breakline
		print "(X)"
		breakline
		print "(Y)"
		breakline
		print "(Z)"
		breakline
		wait 0
		playerX = readline
		wait 0
		playerY = readline
		wait 0
		playerZ = readline
		playerLocation = playerX.val+", "+playerY.val+", "+playerZ.val
		print "cocotransport "+playerLocation
		breakline
		cocotransport playerLocation
	else
		Cococrab_Menu
	end if
end function
Car_Settings = function
	clear
	print "Car Settings"
	breakline
	print "Select with numbers (0-3)"
	breakline
	breakline
	print "1 - Remove car heat"
	breakline
	print "2 - Get current car location (Not currently supported)"
	breakline
	print "3 - Set current car location (Not currently supported)"
	breakline
	print "  - Press any other key to go back"
	wait 0
	carSettingsChoice = readkey

	if carSettingsChoice.val == 1 then
		breakline
		cocoheataway
		print "Set car temperature to 0"
		wait 2
		Car_Settings
	else
		Cococrab_Menu
	end if
end function
// Start with the main menu
main
