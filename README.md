# GoNetSwift
This is the code challenge for GoNet

NOTE: Project was only tested using iPhone Pro or Pro Max.


- This project is not using any third party libraries, however I am using an extension for Color in order to add colors with hex values
and you can find that code in the class Color+Hex.swift.

- This project is using a simple MVC architecture.

- This project is using simple UserDefaults for persistence.

- The only thing I believe I wasn't able to accomplish was swiping from the right. For some reason it was not working and I saw that the method 
func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: was deprecated and you can only use swipe from right to DELETE.

However I was able to use
func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath:
so both swiping to add as a FAVORITE and swiping to DELETE are from left to right.

EXTRA NOTES:
1. At first I was gonna use SwiftUI but then I ended up changin it to only Swift.
2. The project has reusable custom views that I wanted to show.

WHAT COULD BE IMPROVED?
1. Adding a SQLLite Database or Firebase
2. Adding empty screen in case the service fails.
