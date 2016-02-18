## Instructions for change the name and use this project

1) Clone repo.

2) Change the name of the project on the left sidbar in Xcode.

3) Enter on Manage Schemas and change the name to the new one.

4) Close Xcode.

5) Rename the main and the source folder.

6) Right click the project bundle .xcodeproj file and select “Show Package Contents” from the context menu.

7) Open the .pbxproj file with any text editor.

8) Search and replace any occurrence of the original folder name with the new folder name.

9) Save the file.

10) Open Podfile and change the target name with the new name of your project.

11) Run pod install.

12) Done :)
