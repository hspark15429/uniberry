# uniberry

for each table/cell, when you click, possible lectures show up.
When you confirm, it gets filled with lecture's info.
When you cancel, nothing happens.

userData (same in server and client)
    user.uid
    user.email
    user.name
    user.currentTimetable
        int lastupdated
        Map timetable

Page
    TimetablePage
        showTimetable(currentTimetable)
        updateTimetable(newTimetable)
        uploadTimetable()
        

    MenuPage
        void showMenuList()

User logs in
    currentUser = getUserData(uid)
    TimetablePage.showTimetable(currentUser)

a user logs in
the user enters timetablepage
timetablepage gets a timetable from the server and shows it
    TimetablePage.showTimetable(User.uid)
timetablepage renders a timetable based on the localtimetablestate until the user leaves the page (user changes timetable)
    TimetablePage.updateTimetable(localtimetablestate)
when the user leaves the page, timetablepage uploads the latest timetable to the server
    TimetablePage.uploadTimetable(localtimetablestate)

Timetable
    Cell
        Button

dialogResultString()
App Widget Tree
![Uniberry](https://github.com/hspark15429/uniberry/assets/10104871/6015cfbe-182b-47ac-bbee-bfb795d88523)


