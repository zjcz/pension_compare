backup_no_password.zip - produced by running the backup from the app but not setting a password.
backup_with_password.zip - as above but setting a password (password = abc)
empty_export.zip - empty zip file containing no files
invalid_backup.zip - this is an rtf document.
valid_zip_containing_no_json_files.zip - zip file containing no json files at all but a text file (which the app should ignore)

Backup files from the device can be accessed using: 
- Android Studio -> Device Manager -> (Device) -> Device Explorer.  
- Browse to /storage/self/primary/Download/
- Right click file -> save as -> select 'Where' location -> Save
