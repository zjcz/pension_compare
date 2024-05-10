Export is split into several parts

1. First the data from the database is converted into TransferDataModels (see import_export/models and import_export/mapper)
2. Next, the TransferDataModels are converted into ExportDataModel. This is done by the file_handler class used in the export (for example import_formatter/json_export_file_type to export to json)
3. The Data is then written to a file using the file handler (for example the zip_file_handler to export to a zip file)

By splitting the work into seperate sections we can build up the ability to export the data in different formats,for example the backup could export csv files to a zip file, etc, or write each file as a seperate file, depending on the file_handler class used.
