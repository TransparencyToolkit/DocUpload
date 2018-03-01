This is a simple document upload form. To use-

1. Ensure you have sinatra, erb, pry, and dock_integrity_check installed

2. Set the gpg_recipient key ID and lookingglass_url in the config.ru file

3. In this directory, run: rackup config.ru

4. Go to http://localhost:9292/upload/archive_test/ArchiveTestDoc in your
browser

Note that "archive_test" determines the project spec (and index where the data
is saved) and "ArchiveTestDoc" determines the data source spec used. The
project spec parameter should match the config variable in the LookingGlass
initializer.

In the final version, this will be passed by the account/project management
system (with appropriate checks to ensure the user has permission to upload
docs to the project). But because that does not exist yet, we muss pass it as
a manual parameter.

