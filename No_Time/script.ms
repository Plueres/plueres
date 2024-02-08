//HVD override chip maker
//LeeSpork, 2023-10-08
// Instructions: 
// 1. Save this script to your PLC
// (It uses `cd` so it doesn't need to be installed on the disk; having it on the PLC's directory is fine.)
// 2. Insert a new HVD chip
// 3. Run this script from the PLC, entering the year when prompted
// 4. Eject the HVD and craft it into a chip with your Mr. Crafty :)
// If you are in cococrab mode, it will even spawn you a circuitboard

print("Make sure you have a new HVD inserted.")
breakline
cd "Item_HoloDisk(Clone)"
print("Enter year: ")
year = readline

// Check for leading '-'
if year[0] == "-" then
 epoch = "-"
 year = slice(year, 1)
else
 epoch = ""
end if
// Make sure year is 4 digits
if len(year) > 4 then
 print("Too many digits!"); breakline
else
 while len(year) < 4
  year = "0" + year
 end while

 day = "01"
 month = "04"
 hour = "08"
 minute = "00"
 timestring = epoch + month + day + year + hour + minute

 create "startup.eee"
 writeline "startup.eee", 0, "overridedate " + timestring
 setlabel epoch + year + "chip"

 breakline
 print("Set up a chip to ")
 print(timestring); breakline
 cocogive 35 // Give a computer board
 print("Eject and craft it!"); breakline
end if

breakline
// Go back to PLC directory
cd "FPSController"