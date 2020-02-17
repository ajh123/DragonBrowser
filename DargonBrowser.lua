term.clear()
term.setCursorPos(1,1)
function job()
      --do stuff
end
function splash()
     term.setBackgroundColour(colours.blue)
     term.clear()
     print([[
________                                           
\______ \____________    ____   ____   ____        
 |    |  \_  __ \__  \  / ___\ /  _ \ /    \       
 |    `   \  | \// __ \/ /_/  >  <_> )   |  \      
/_______  /__|  (____  |___  / \____/|___|  /      
________\/           \/_____/             \/       
\______   \______  ______  _  ________ ___________ 
 |    |  _|_  __ \/  _ \ \/ \/ /  ___// __ \_  __ \
 |    |   \|  | \(  <_> )     /\___ \\  ___/|  | \/
 |______  /|__|   \____/ \/\_//____  >\___  >__|   
        \/                         \/     \/       ]])
end
--parrallel.waitForAll(job, splash)
splash()
sleep(2)
term.setBackgroundColour(colours.black)
term.clear()
term.setCursorPos(1,1)

lines = {}
web_page = {}
title = ""
code = ""
page = {}
count = 1
centered = false
hFile = ""
term.setBackgroundColour(colours.grey)
print([[+-------------------------------------------------+
|
|
+-------------------------------------------------+]])
term.setCursorPos(2,2)
print("Enter remote index file or local file >")
term.setCursorPos(2,3)
site = io.read()
term.setBackgroundColour(colours.black)

local function get(repoFile,saveTo)

local download = http.get("https://raw.github.com/ajh123/DragonBrowser/master/web/"..repoFile) --This will make 'download' hold the contents of the file.
if download then --checks if download returned true or false
   local handle = download.readAll() --Reads everything in download
   download.close() --remember to close the download!
   local file = fs.open(saveTo,"w") --opens the file defined in 'saveTo' with the permissions to write.
   file.write(handle) --writes all the stuff in handle to the file defined in 'saveTo'
   file.close() --remember to close the file!
  else --if returned false
   print("Unable to download the file "..repoFile)
   print("Make sure you have the HTTP API enabled or")
   print("an internet connection!")
  end --end the if
end --close the function

get(site, "web.html")

if fs.exists("web.html") then
	hFile = fs.open("web.html", "r")
else
 	hFile = fs.open(site, "r")
end
-- Read all file
while true do
        h = hFile.readLine()
        if h == nil then break
        else
                lines[count] = h
                count = count + 1
        end
end
hFile.close()
-- Get rid of all spacing
for k, v in pairs(lines) do
        h, e = string.find(v, "<")
        str = string.sub(v, h)
        web_page[#web_page + 1] = str
end
-- Finding Paragraphs, title, headers, etc.
for k, v in pairs(web_page) do
        p = string.find(v, "p>")
        hed = string.find(v, "h1>")
        t = string.find(v, "title>")
        s = string.find(v, "LUAscr>")
        cen = string.find(v, "<center>")
        end_cen = string.find(v, "</center>")
               
        if t then
                ti = string.gsub(v, "<", "")
                tit = string.gsub(ti, ">", "")
                title = string.sub(tit, 6, -7)
        elseif s then
                sc = string.gsub(v, "<", "")
                scr = string.gsub(sc, ">", "")
                script = string.sub(scr, 7, -8)
                get(site..script, "script.LUAscr")
                scriptFile = fs.open("script.LUAscr", "r")
                if scriptFile then
                	code = scriptFile.readAll() 
                	scriptFile.close()
                end 
        elseif p then
                prt = string.gsub(v, "<", "")
                err = string.gsub(prt, ">", "")
                ern = string.sub(err, 2, -3)
                page[#page + 1] = ern
        elseif hed then
                he = string.gsub(v, "<", "")
                hea = string.gsub(he, "<", "")
                head = string.sub(hea, 4, -5)
                page[#page + 1] = head
        elseif cen then
                page[#page + 1] = "center"
        elseif end_cen then
                page[#page + 1] = "end_cen"
        end
end
term.clear()
term.setCursorPos(1,1)
term.setBackgroundColour(colours.grey)
web = string.format([[+-------------------------------------------------+
|Page: %s
|
+-------------------------------------------------+]], title)
print(web)
term.setBackgroundColour(colours.black)
loadstring(code)()
for k, v in pairs(page) do
    if v == "center" then
        centered = true
    elseif v == "end_cen" then
        centered = false
    elseif centered then
        local x, y = term.getSize()
        local gx, gy = term.getCursorPos()
        term.setCursorPos((x/2)-(string.len(v)/2), gy)
        print(v)
    else
        print(v)
    end
end
shell.run("rm ", "web.html")
