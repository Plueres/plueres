// Quick Menu Script
// By: Thers
// TODO: add the sign for checks that use negative numbers
// TODO: add actual settings for the script
// TODO: when creating hvd chip, remove Label.eee file
//* can remove the line of lowering the characters in the dialgate code for space

// Variables
connectionTime = 2
enableMonthNames = false

// Convert month number to month shortname
MonthName = function(monthnumber)
	if enableMonthNames == false then return monthnumber
	months = {01:"Jan", 02:"Feb", 03:"Mar", 04:"Apr", 05:"May", 06:"Jun", 07:"Jul", 08:"Aug", 09:"Sep", 10:"Oct", 11:"Nov", 12:"Dec"}
    for i in months.indexes
		if monthnumber.val == i then
            return months[i]
        end if
	end for
	return "Invalid. entering default: May"
end function

// Create a history file
Travel_History = function
	//Create History File
	if find ("Travel History") == -1 then
		breakline
		print "'Travel History' "
		create "Travel History"
		writeline "Travel History", 0, "Travel History:"
	end if
end function

// The main function / landing page
main = function
	clear
	// Print ASCII Art
	print "    ____        _      _        __  __                  "
	breakline
	print "   / __ \      (_)    | |      |  \/  |                 "
	breakline
	print "  | |  | |_   _ _  ___| | __   | \  / | ___ _ __  _   _ "
	breakline
	print "  | |  | | | | | |/ __| |/ /   | |\/| |/ _ \ '_ \| | | |"
	breakline
	print "  | |__| | |_| | | (__|   <    | |  | |  __/ | | | |_| |"
	breakline
	print "   \___\_\\__,_|_|\___|_|\_\   |_|  |_|\___|_| |_|\__,_| v1.5.1"
	breakline
	breakline
	print "1 - Time Travel                2 - Space Travel"
	breakline
	print "3 - Return from Time Travel    4 - Return from Space Travel"
	breakline
	print "5 - Cococrab Mode              6 - Create HVD Chip"
	breakline
	print "7 - Other Functions                (Needs HVD Chip in the PLC)"
	breakline
	choice = readkey
	functions = {1:@TimeModule, 2:@SpaceModule, 3:@RecallTimeGate, 4:@RecallSpaceGate, 5:@CococrabMode, 6:@CreateChip, 7:@OtherFunctions}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	main
end function

// The function to travel through time with the dimension gate
TimeModule = function
	clear
	connectgate
	wait connectionTime
	breakline
	print "1 - Random Date and Time"
	breakline
	print "2 - Enter Date and Time"
	breakline
	print "    Press any other key to go back"
	choice = readkey
	functions = {1:@TimeModule_RandomDateTime, 2:@TimeModule_EnterDateTime}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	main
end function
TimeModule_RandomDateTime = function
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
	// Add month
	month = RandomTime(ceil(rnd * 12))
	// Add day
	day = RandomTime(ceil(rnd * 30))
	// Add hour
	hour = RandomTime(floor(rnd * 24))
	// Add minute
	minute = RandomTime(floor(rnd * 60))
	// check if the year is negative
	year = floor((0-3795) + (2077 - (0-3795)) * rnd)
	year = str(year)
	if year[0] == "-" then
		epoch = ""
		// Could be a '-' if negative years worked with the dimension gate
		year = slice(year, 1)
	else
		epoch = ""
	end if
	while year.len < 4
		year = "0" + year
	end while
	clear
	print "Random address:"
	breakline
	print "Day: " + day
	breakline
	print "Month: " + MonthName(month)
	breakline
	print "Year: " + epoch + year
	breakline
	print "Date: " + day + " " + MonthName(month) + " " + epoch + year
	breakline
	print "Time: " + hour + ":" + minute
	breakline
	Overridedate_Value = epoch + month + day + year + hour + minute;
	dialgate Overridedate_Value //start dialing the address
	Travel_History()
	writeline "Travel History", countlines("Travel History")+1, "Random Date: " + day + " " + MonthName(month) + " " + epoch + year + " " + hour + ":" + minute
	breakline
	wait 3
	print "Press any button to go back"
	readkey
	TimeModule
end function
TimeModule_EnterDateTime = function
	clear
	print "Enter Day:"
	day = readline
	while day.len < 2
		day = "0" + day
	end while
	wait 0
	if day.val <= 31 then
		clear
		print "Day: " + day
		breakline
		print "Enter Month:"
		month = readline
		while month.len < 2
			month = "0" + month
		end while
		wait 0
		if month.val <= 12 then
			clear
			print "Day: " + day
			breakline
			print "Month: " + MonthName(month)
			breakline
			print "Enter Year:"
			year = readline
			// Check for leading '-'
			if year[0] == "-" then
				epoch = "-"
				year = slice(year, 1)
			else
				epoch = ""
			end if
			while year.len < 4
				year = "0" + year
			end while
			wait 0
			if year.val <= 2076 then
				clear
				print "Day: " + day
				breakline
				print "Month: " + MonthName(month)
				breakline
				print "Year: " + year
				breakline
				print "Enter Hour as Number (HH)"
				hour = readline
				while hour.len < 2
					hour = "0" + hour
				end while
				wait 0
				if hour.val <= 24 then
					clear
					print "Day: " + day
					breakline
					print "Month: " + MonthName(month)
					breakline
					print "Year: " + year
					breakline
					print "Hour: " + hour
					breakline
					print "Enter Minute as Number (MM)"
					minute = readline
					while minute.len < 2
						minute = "0" + minute
					end while
					if minute.val > 59 then
						minute = 59
					end if
					wait 0
				else
					hour = "23"
				end if
			else 
				year = "2014"
			end if
		else 
			month = "05"
		end if
	else
		day = "11"
	end if
	clear
	Overridedate_Value = epoch + month + day + year + hour + minute
	dialgate Overridedate_Value
	print "You Entered:"
	breakline
	print "Day: " + day
	breakline
	print "Month: " + MonthName(month)
	breakline
	print "Year: " + epoch + year
	breakline
	print "Date: " + day + " " + MonthName(month) + " " + epoch + year
	breakline
	print "Time: " + hour + ":" + minute
	breakline
	print Overridedate_Value
	breakline
	Travel_History()
	writeline "Travel History", countlines("Travel History")+1, "Date: " + day + " " + MonthName(month) + " " + year + " " + hour + ":" + minute
	breakline
	wait 3
	print "Press any button to go back"
	readkey
	TimeModule
end function

// The function to travel through space with the dimension gate
SpaceModule = function
	clear
	connectgate
	wait connectionTime
	breakline
	print "1 - Random Dialgate Code"
	breakline
	print "2 - Enter Dialgate Code"
	breakline
	print "    Press any other key to go back"
	choice = readkey
	functions = {1:@SpaceModule_RandomDialgateCode, 2:@SpaceModule_EnterDialgateCode}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	main
end function
SpaceModule_RandomDialgateCode = function
	// Generate random space gate address
	Space_Coordinate = ""
	for i in range(1, 5)
		Space_Coordinate = Space_Coordinate + char(rnd * 24 + 97)
	end for
	breakline
	dialgate Space_Coordinate.lower
	Travel_History()
	writeline "Travel History", countlines("Travel History")+1, "Random Planet Code: " + Space_Coordinate.upper
	wait 3
	print "Press any button to go back"
	breakline
	readkey
	SpaceModule
end function
SpaceModule_EnterDialgateCode = function
	clear
	print "Please enter Coordinates using 5 characters (A-X)"
	wait 0
	Space_Coordinate = readline
	while Space_Coordinate.len < 5
		Space_Coordinate = char(rnd * 24 + 97) + Space_Coordinate
	end while
	if Space_Coordinate.len < 5 then // if it is not exactly 5 characters then exit
		print "Please enter the correct format"
		wait
		SpaceModule
	end if
	dialgate Space_Coordinate.lower
	Travel_History()
	writeline "Travel History", countlines("Travel History")+1, "Planet Code: " + Space_Coordinate.upper
	wait 3
	breakline
	print "Press any button to go back"
	readkey
	SpaceModule
end function

RecallTimeGate = function
	recalltimegate
	wait 3
	breakline
	print "Press any button to go back"
	readkey
	main
end function 

RecallSpaceGate = function
	connectgate
	breakline
	print "Please wait until it starts dialing"
	wait 2
	dialgate "xxxxx"
	wait 3
	breakline
	print "Press any button to go back"
	readkey
	main
end function

// TODO: add UI for cococrab
// Enable cheats
CococrabMode = function
	print "Do you want to enable Cococrab Mode? (Cheats)"
	breakline
	print "(Y)es or (N)o"
	breakline
	print "WARNING: Cococrab Mode will disable Steam Achievements for the current session"
	breakline
	enableCheats = readkey
	
	if enableCheats == "y" then
		cococrab
		print "Cococrab Mode enabled"
		wait
		CococrabMenu
	else 
		print "Cococrab mode will not be enabled. Aborting..."
		wait
		main
	end if
end function
// The menu for Cococrab Mode
CococrabMenu = function
	clear
	print "Cococrab Mode is enabled"
	breakline
	print "To disable Cococrab mode reload the current save file"
	breakline
	breakline
	print "1 - Give Money"
	breakline
	print "2 - Teleport"
	breakline
	print "3 - Spawn Items"
	breakline
	print "4 - Change Time"
	breakline
	print "5 - Change Time Speed"
	breakline
	print "6 - Player Setting"
	breakline
	print "7 - Car Settings"
	breakline
	print "9 - Next Page"
	breakline
	print "    Press any other key to go back"

	choice = readkey
	functions = {1:@CococrabMenu_GiveMoney, 2:@CococrabMenu_Teleport, 3:@CococrabMenu_SpawnItems, 4:@CococrabMenu_ChangeTime, 5:@CococrabMenu_ChangeTimeSpeed, 6:@CococrabMenu_PlayerSettings, 7:@CococrabMenu_CarSettings, 9:@CococrabMenu2}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	main
end function

// Function to give yourself any amount of money
CococrabMenu_GiveMoney = function
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
	print "    Press any other key to go back"
	choice = readkey
	functions = {1:@CococrabMenu_GiveMoney_Shillings, 2:@CococrabMenu_GiveMoney_Dollars, 3:@CococrabMenu_GiveMoney_Imperial, 4:@CococrabMenu_GiveMoney_All}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
			wait
			CococrabMenu_GiveMoney
		end if
	end for
	CococrabMenu
end function
CococrabMenu_GiveMoney_Shillings = function
	breakline
	print "How much shillings do you want to get?"
	breakline
	wait 0
	moneyAmountChoice = readline
	cocoshilling moneyAmountChoice.val
end function
CococrabMenu_GiveMoney_Dollars = function
	breakline
	print "How much dollars do you want to get?"
	breakline
	wait 0
	moneyAmountChoice = readline
	cocodollar moneyAmountChoice.val
end function
CococrabMenu_GiveMoney_Imperial = function
	breakline
	print "How much imperial dollars do you want to get?"
	breakline
	wait 0
	moneyAmountChoice = readline
	cocoimperial moneyAmountChoice.val
end function
CococrabMenu_GiveMoney_All = function
	breakline
	print "How much money do you want to get?"
	breakline
	wait 0
	moneyAmountChoice = readline
	cocoshilling moneyAmountChoice.val
	cocodollar moneyAmountChoice.val
	cocoimperial moneyAmountChoice.val
end function

// Function to teleport
CococrabMenu_Teleport = function
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
	print "    Press any other key to go back"
  	breakline
  	wait 0
  	choice = readkey
  	clear

	functions = {1:@CococrabMenu_Teleport_StartLocation, 2:@CococrabMenu_Teleport_BillsGarage, 3:@CococrabMenu_Teleport_PineCityGarage, 4:@CococrabMenu_Teleport_ERAthorsLab, 5:@CococrabMenu_Teleport_Bridgetown, 6:@CococrabMenu_Teleport_CapeDun, 7:@CococrabMenu_Teleport_CafeSkylight, 8:@CococrabMenu_Teleport_UroruhPeak}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
			wait
			CococrabMenu_Teleport
		end if
	end for
	CococrabMenu
end function
CococrabMenu_Teleport_StartLocation = function
	// Default starting location by the big bridge. Car and player.
	cocotransport 20, 44, -1127
	cococarport 26, 42, -1128
end function
CococrabMenu_Teleport_BillsGarage = function
	//Bills garage
	if getyear < 1940 or getyear > 2026 then
		cocoyear 2014
		yield
	end if
	cocotransport -5, 0, -125
	cococarport -9, -2, -128
end function
CococrabMenu_Teleport_PineCityGarage = function
	//Pine City garage
	if getyear < 2045 or getyear > 2074 then
		cocoyear 2060
		yield
	end if
	cocotransport -10, 182, -100 
	cococarport -16, 180, -99
end function
CococrabMenu_Teleport_ERAthorsLab = function
	//E. R. Athors Lab.
	cocotransport 0,0,0
end function
CococrabMenu_Teleport_Bridgetown = function
	//Bridgetown (taxi sitting area)
	if getyear < 2007 or getyear > 2026 then
		cocoyear 2014
	end if
	cocotransport -55, 73, 2100
end function
CococrabMenu_Teleport_CapeDun = function
	//Cape Dun
	cocotransport -223, -7, 2044
end function
CococrabMenu_Teleport_CafeSkylight = function
	//Just outside Caffè Skylight
	if getyear < 2045 or getyear > 2074 then
		cocoyear 2060 
	end if	
	cocotransport 225, 215, 0
end function
CococrabMenu_Teleport_UroruhPeak = function
	//Mt. Uroruh Peak
	cocotransport -20, 500, 1160
end function

// Function to spawn items in cococrab mode
CococrabMenu_SpawnItems = function
	clear
	print "1 - List all items and their ID's (known to cause some lag, please be patient) (cannot scroll)"
	breakline
	print "2 - Cocogive. Give yourself an item by its ID"
	breakline
	print "    Press any other key to go back"
	wait 0
	choice = readkey
	functions = {1:@CococrabMenu_SpawnItems_List, 2:@CococrabMenu_SpawnItems_GiveItem}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
			wait
			CococrabMenu_SpawnItems
		end if
	end for
	CococrabMenu
end function
CococrabMenu_SpawnItems_List = function
	clear
	cocoitems
	wait 0
end function
CococrabMenu_SpawnItems_GiveItem = function
	breakline
	print "Enter an item ID"
	wait 0
	itemID_Choice = readline
	cocogive itemID_Choice.val
	breakline
	print "Given the item " + itemID_Choice.val + ". Which will now be in front of you on the ground"
	wait 2
	clear
	SpawnItems
end function

// Function to change current time of day
CococrabMenu_ChangeTime = function
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
	print "    Press any other key to go back"
	breakline
	choice = readkey
	functions = {2:95, 3:150, 4:180, 5:225, 6:265, 7:290, 8:0, 9:45}
	for i in functions.indexes
		if choice.val == 1 then
			CococrabMenu_ChangeTime_EnterTime
		end if
		if choice.val == i then
			cocotime functions[i]
		end if
		wait
		CococrabMenu
	end for
	CococrabMenu
end function
CococrabMenu_ChangeTime_EnterTime = function
	clear
	print "Select a number from 0-360"
	breakline
	wait 0
	changeTimeValue = readline
	cocotime changeTimeValue.val
	wait
	CococrabMenu_ChangeTime
end function

CococrabMenu_ChangeTimeSpeed = function
	clear
	print "Change time speed to:"
	breakline
	print "1 - Own input"
	breakline
	print "2 - Default"
	breakline
	print "3 - 0.5x Speed"
	breakline
	print "4 - 2x Speed"
	breakline
	print "5 - 4x Speed"
	breakline
	print "6 - 10x Speed"
	breakline
	print "  - Press any other key to go back"

	choice = readkey
	functions = {2:1.0, 3:0.5, 4:2.0, 5:4.0, 6:10.0}
	for i in functions.indexes
		if choice.val == 1 then
			CococrabMenu_ChangeTimeSpeed_Enter
		end if
		if choice.val == i then
			print "button: " + choice.val
			print "i: " + i
			breakline
			cocospeed functions[i]
		end if
	end for
	wait
	CococrabMenu_ChangeTimeSpeed
end function
CococrabMenu_ChangeTimeSpeed_Enter = function
	clear
	print "Enter a value"
	breakline
	print "Values above 1,000,000 can cause severe lag. And values around 1,000,000,000,000 may freeze/crash the game. This may differ per device"
	breakline
	wait 0
	changeTimeSpeedOwnInput = readline
	cocospeed changeTimeSpeedOwnInput.val
end function

// Function to change attributes of the player
CococrabMenu_PlayerSettings = function
	clear
	print "Player Settings"
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
	print "    Press any other key to go back"
	breakline
	choice = readkey
	functions = {1:@CococrabMenu_PlayerSettings_Heal, 2:@CococrabMenu_PlayerSettings_ClearRadiation, 3:@CococrabMenu_PlayerSettings_GetLocation, 4:@CococrabMenu_PlayerSettings_SetLocation}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	CococrabMenu
end function
CococrabMenu_PlayerSettings_Heal = function
	breakline
	cocoheal
	print "Player Healed"
	wait 2
	PlayerSettings
end function
CococrabMenu_PlayerSettings_ClearRadiation = function
	breakline
	cocorads
	print "Player cleared of radiation"
	wait 2
	PlayerSettings
end function
CococrabMenu_PlayerSettings_GetLocation = function
	breakline
	print "Current location is: "
	cocotransport
	wait 
	CococrabMenu_PlayerSettings
end function
CococrabMenu_PlayerSettings_SetLocation = function
	print "Enter a location:"
	breakline
	print "X, Y, Z"
	breakline
	choice = readline
	playerLocation = choice
	print "cocotransport "+playerLocation
	breakline
	cocotransport playerLocation
end function

// Function to change attributes of the car
CococrabMenu_CarSettings = function
	clear
	print "Car Settings"
	breakline
	breakline
	print "1 - Remove car heat"
	breakline
	print "2 - Get current car location (Not currently supported)"
	breakline
	print "3 - Set current car location (Not currently supported)"
	breakline
	print "    Press any other key to go back"
	choice = readkey
	functions = {1:@CococrabMenu_CarSettings_CoolCar, 2:@CococrabMenu_CarSettings_GetLocation, 3:@CococrabMenu_CarSettings_SetLocation}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	CococrabMenu
end function
CococrabMenu_CarSettings_CoolCar = function
	breakline
	cocoheataway
	print "Car cooled down"
	wait 2
	CarSettings
end function
CococrabMenu_CarSettings_GetLocation = function
	breakline
	print "Current location is: "
	cococarport
	wait 
	CococrabMenu_PlayerSettings
end function
CococrabMenu_CarSettings_SetLocation = function
	print "Enter a location:"
	breakline
	print "X, Y, Z"
	breakline
	choice = readline
	carLocation = choice
	print "cococarport " + carLocation
	breakline
	cococarport carLocation
end function

// The second page of the Cococrab Menu
CococrabMenu2 = function
	clear
	print "Cococrab Mode is enabled"
	breakline
	print "Page 2"
	breakline
	breakline
	print "1 - Quick Save (Not working)"
	breakline
	print "2 - Get current quest name and ID (Not currently supported)"
	breakline
	print "3 - Set current quest progress (Not currently supported)"
	breakline
	print "  - Press any other key to go back"


	choice = readkey
	functions = {1:@CococrabMenu2, 2:@CococrabMenu2, 3:@CococrabMenu2}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
			wait
			CococrabMenu2
		end if
	end for
	CococrabMenu
end function
// Save Game
CococrabMenu2_QuickSave = function
	breakline
	cocosave
	print "Saved Game"
end function
CococrabMenu2_GetQuest = function
	breakline
	cocogetqname
	wait 
	CococrabMenu2
end function
CococrabMenu2_SetQuest = function
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
		CococrabMenu2
	end if
	cocoquest + questID + questStatusLabel
end function

// Menu to quickly create an HVD chip
CreateChip = function
	clear
	cd "Item_HoloDisk(Clone)"
	breakline
	print "1 - Overridedate"
	breakline
	print "2 - Overridedate (Automatic)"
	breakline
	print "3 - Set chip label"
	breakline
	print "    Press any other key to go back"
	breakline

	choice = readkey
	functions = {1:@CreateChip_Overridedate, 2:@CreateChip_OverridedateYear, 3:@CreateChip_SetLabel}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	cd "FPSController"
	main
end function
// Command to transfer the overridedate function to a chip
CreateChip_Overridedate = function
	clear
	print "This command will create a file called startup.eee if it doesn't already exist"
	breakline
	wait 1.5
	clear
	print "Enter Day:"
	day = readline
	while len(day) < 2
		day = "0" + day
	end while
	wait 0
	if day.val <= 31 then
		clear
		print "Day: " + day
		breakline
		print "Enter Month:"
		month = readline
		while len(month) < 2
			month = "0" + month
		end while
		wait 0
		if month.val <= 12 then
			clear
			print "Day: " + day
			breakline
			print "Month: " + MonthName(month)
			breakline
			print "Enter Year:"
			year = readline
			// Check for leading '-'
			if year[0] == "-" then
				epoch = "-"
				year = slice(year, 1)
			else
				epoch = ""
			end if
			while len(year) < 4
				year = "0" + year
			end while
			wait 0
			if year.val <= 2076 then
				clear
				print "Day: " + day
				breakline
				print "Month: " + MonthName(month)
				breakline
				print "Year: " + year
				breakline
				print "Enter Hour as Number (HH)"
				hour = readline
				while len(hour) < 2
					hour = "0" + hour
				end while
				wait 0
				if hour.val <= 24 then
					clear
					print "Day: " + day
					breakline
					print "Month: " + MonthName(month)
					breakline
					print "Year: " + year
					breakline
					print "Hour: " + hour
					breakline
					print "Enter Minute as Number (MM)"
					minute = readline
					while len(minute) < 2
						minute = "0" + minute
					end while
					if minute.val <= 59 then
					end if
					wait 0
				end if
			end if
		end if
	end if
	clear
	print "You Entered:"
	breakline
	print "Day: " + day
	breakline
	print "Month: " + MonthName(month)
	breakline
	print "Year: " + epoch + year
	breakline
	print "Date: " + day + " " + MonthName(month) + " " + epoch + year
	breakline
	print "Time: " + hour + ":" + minute
	Overridedate_Value = epoch + month + day + year + hour + minute
	breakline
	print Overridedate_Value
	breakline
	if find ("startup.eee") != -1 then
		lines = countlines ("startup.eee")
	end if
	Overridedate_Pos_Value = day + month + year + hour + minute
	if Overridedate_Pos_Value.len == 12 then
		CheckStartupFile(lines, Overridedate_Value)
	else
		print "ERROR: Invalid input. Aborting"
		cd "FPSController"
	end if
	breakline
	cd "FPSController"
	wait 3
	print "Press any button to go back"
	readkey
	CreateChip
end function
// Create a chip with only the year - can be quicker
CreateChip_OverridedateYear = function
	clear
	print "This command will make it easier to make timechips. You'll only have to enter the year"
	breakline
	wait 1.5
	clear
	print "Enter Year: (Can be negative)"
	year = readline
	// Check for leading '-'
	if year[0] == "-" then
		epoch = "-"
		year = slice(year, 1)
	else
		epoch = ""
	end if
	while len(year) < 4
		year = "0" + year
	end while
	Overridedate_Value = epoch + "06" + "16" + year + "10" + "10"
	breakline
	print Overridedate_Value
	breakline
	if find ("startup.eee") != -1 then
		lines = countlines ("startup.eee")
	else 
		lines = 0
	end if
	setlabel epoch + year + "chip"
	CheckStartupFile(lines, Overridedate_Value)
	breakline
	cd "FPSController"
	wait 3
	print "Press any button to go back"
	readkey
	CreateChip
end function
// Set the label of the chip
CreateChip_SetLabel = function
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
		cd "FPSController"
		main
	else
		breakline
		print "Did not set the chip name to " + chipName
		wait
		CreateChip
	end if
end function

// Check if the startup.eee file exists
CheckStartupFile = function(linecount, value)
	print "Checking if file exists and if it is empty"
	breakline
	wait
	if find ("startup.eee") == -1 then
		print "File doesn't exist yet, creating file."
		wait
		print "."
		wait
		print "."
		breakline
		create "startup.eee"
		wait
		print "Writing lines."
		wait
		print "."
		wait
		print "."
		breakline
		writeline "startup.eee", 0, "overridedate " + value
		print "Done"
		wait 0.5
		breakline
		cd "FPSController"
		wait 3
		print "Press any button to go back"
		readkey
		CreateChip
	else if linecount < 1 then
		print "Nothing in the file yet, writing."
		wait
		print "."
		wait
		print "."
		breakline
		wait
		writeline "startup.eee", linecount, "overridedate " + value
		print "Done"
		breakline
		wait 0.5
		cd "FPSController"
		wait 3
		print "Press any button to go back"
		readkey
		CreateChip
	else
		print "startup.eee has existing lines, overwriting."
		wait
		print "."
		wait
		print "."
		breakline
		wait
		print "Writing into file."
		wait 0.5
		print "."
		wait 0.5
		print "."
		breakline
		writeline "startup.eee", linecount, "overridedate " + value
		print "Done"
		wait 0.5
		breakline
		cd "FPSController"
		wait 3
		print "Press any button to go back"
		readkey
		CreateChip
	end if
end function

// Settings for the script
OtherFunctions = function 
	clear
	print "Other functions:"
	breakline
	print "1 - Timegraph"
	breakline
	print "2 - Check if you can travel to a certain year"
	breakline
	print "3 - Car Diagnostics"
	breakline
	print "4 - Last location/date traveled to with dimension gate"
	breakline
	print "    Press any other key to go back"
	breakline
	choice = readkey
	functions = {1:@OtherFunctions_Timegraph, 2:@OtherFunctions_CheckYear, 3:@OtherFunctions_CarDiag, 4:@OtherFunctions_LastTraveled}
	for i in functions.indexes
		if choice.val == i then
			functions[i]()
		end if
	end for
	main
end function
OtherFunctions_Timegraph = function
	bgcolor 0,0,0	
	timegraph
	clear
	wait 0
end function
OtherFunctions_CheckYear = function
	print "Enter a year"
	choice = readline
	breakline
	if choice[0] == "-" then
		strippedchoice = slice(choice, 1)
	else
		strippedchoice = choice
	end if
	if cantravel(choice.val) == 1 and strippedchoice.len <= 4 then
		print "Traveling to the year " + choice.val + " is possible"
		wait 2
		OtherFunctions
	else
		print "Traveling to the year " + choice.val + " is not possible"
		wait 2
		OtherFunctions
	end if
end function
OtherFunctions_LastTraveled = function
	print "Last traveled to:"
	breakline
	if countlines("Travel History") < 1 then
		print "Could not find any travel history"
	else
		print readfile("Travel History", countlines("Travel History")-1)
	end if
	wait 2
	OtherFunctions
end function
OtherFunctions_CarDiag = function
	cardiag
	wait 3
	OtherFunctions
end function

// Start the script with the main menu
main