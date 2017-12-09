// starts the assistant GUI

runoncepath("/lib/utils").
runoncepath("/lib/gui/main").

clearguis().

//hudtext("Starting flight assistant GUI", 3, 1, 15, blue, true).
notify("Starting flight assistant GUI").
startgui().