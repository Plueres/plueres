// errorOccurred = false
// getconnectionstatus = false;

// connectgate = function
//     // Some code...
//     if errorOccurred == null then
//         errorOccurred = true
//     end if
// end function

// connectgate
// wait 2
// if errorOccurred then
//     print "An error occurred while trying to establish a connection."
//     getconnectionstatus = false
// else
//     getconnectionstatus = true
//     connection = getconnectionstatus
//     if connection then
//         print "Connection successful"
//         connectgate
//     else
//         print "Connection failed"
//     end if
// end if

start = function(number)
    months = {01:"Jan", 02:"Feb", 03:"Mar", 04:"Apr", 05:"May", 06:"Jun", 07:"Jul", 08:"Aug", 09:"Sep", 10:"Oct", 11:"Nov", 12:"Dec"}

    for i in range(months.indexes, 12)
		if str(i).len <= 1 then
            i + "0" + number
        end if
		if number.val == i then
            return months[i]
		else 
			print i
        end if
        // print months[round(number)]
        // // remove(str(number).indexOf(0))
        // print str(number).indexOf(0)
        // // if number.indexOf(0) == "0" then
        // //     print "yeah" + number.indexOf(0)
        // // end if
        // print number
        // breakline



        // number.split("0");
        // print str(number).indexOf(0)
        // while str(number) == 2
        //     // str(number)[0] == 0
        //     number = "0" - number
		// end while
        // if (number == i) then
        //     return months[5]
        // end if
    end for

    // for i in range(1, 10)
    //     print i
    // end for

settings = readfile("settings").remove("settings = ")
print settings isa map

if find("settings") != -1 then
    enableMonthName = settings["enableMonthName"]
else 
    enableMonthName = false
end if
breakline
print enableMonthName




	// if monthnumber == "01" then
	// 	return "Jan"
	// else if monthnumber == "02" then
	// 	return "Feb"
	// else if monthnumber == "03" then
	// 	return "Mar"
	// else if monthnumber == "04" then
	// 	return "Apr"
	// else if monthnumber == "05" then
	// 	return "May"
	// else if monthnumber == "06" then
	// 	return "Jun"
	// else if monthnumber == "07" then
	// 	return "Jul"
	// else if monthnumber == "08" then
	// 	return "Aug"
	// else if monthnumber == "09" then
	// 	return "Sep"
	// else if monthnumber == "10" then
	// 	return "Oct"
	// else if monthnumber == "11" then
	// 	return "Nov"
	// else if monthnumber == "12" then
	// 	return "Dec"
	// end if
end function
print start("06");













main = function
    print "Hello";
end function

main.print = function
    print "Hello World"
end function

main.print














prompts = ["Enter a day: ", "Enter a month: ", "Enter a year: ", "Enter an hour: ", "Enter a minute: "]
maxVals = [31, 12, 2076, 23, 59]
strings = {"Day: ": null, "Month: ": null, "Year: ": null, "Hour: ": null, "Minute: ": null}
enterStr = ["Day: ", "Month: ", "Year: ", "Hour: ", "Minute: "]
promptIndex = 0
askInput = function()
    clear
    print "old: " + promptIndex
    breakline
    for key in prompts.indexes
        if strings[enterStr[key]] != null then
            print enterStr[key] + strings[str(enterStr[key])]
            breakline
        end if
    end for
    print prompts[promptIndex]
    input = readline //* inputs get replaced by readline
    strings[enterStr[promptIndex]] = input //* push the input into the strings map
    wait
    // for testing purposes
    print strings
    breakline
    print "entered: " + strings[enterStr[promptIndex]].val
    breakline
    print "max: " + maxVals[promptIndex]
    number = strings[enterStr[promptIndex]].val
    max = maxVals[promptIndex]
    wait
        promptIndex = promptIndex + 1

    if number < max then
        breakline
        print "new: " + promptIndex
        wait 3
        return input.val//? now it does go here but doesn't update the prompt index after reloading the function
    else
        print "is bigger than " + maxVals[promptIndex]
        wait 2
        return maxVals[promptIndex]
    end if
end function
CreateChip_Overridedate = function
    clear
    day = askInput
    breakline
    print promptIndex + "lololololol" //! never gets here
    if day isa number then
        month = askInput
        if month != null then
            year = askInput
            if year != null then
                hour = askInput
                if hour != null then
                    minute = askInput
                end if
            end if
        end if
    end if
    wait 2
    while len(day) < 2
		day = "0" + day
	end while
    while len(month) < 2
        month = "0" + month
    end while
    while len(year) < 4
        year = "0" + year
    end while
    while len(hour) < 2
        hour = "0" + hour
    end while
    while len(minute) < 2
        minute = "0" + minute
    end while
    wait
    if find ("startup.eee") != -1 then
		lines = countlines ("startup.eee")
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
	print "Time: " + hour + ":" + minute
	Overridedate_Value = epoch + month + day + year + hour + minute
	breakline
    wait
	print Overridedate_Value
	breakline
	Overridedate_Pos_Value = day + month + year + hour + minute
	if Overridedate_Pos_Value.len == 12 then
		CheckStartupFile(lines, Overridedate_Value)
	else
		print "ERROR: Invalid input. Aborting"
		cd "FPSController"
	end if
    wait
	breakline
	cd "FPSController"
	wait 3
	print "Press any button to go back"
	readkey
	CreateChip
end function
CreateChip_Overridedate