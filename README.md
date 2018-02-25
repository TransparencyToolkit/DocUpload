This is a simple document upload form. To use-

1. Ensure you have sinatra, erb, pry, and dock_integrity_check installed

2. Set the gpg_recipient key ID in the config.ru file

3. In this directory, run: rackup config.ru

4. Go to http://localhost:9292/upload/filler_project in your browser
Note that "filler_project" is a parameter that determines the dataspec used,
much like the config variable in the LookingGlass initializers does. When
hooked up to DocManager, the project param should be set to the name of the
index of the dataspec for the project.

In the final version, this will be passed by the account/project management
system (with appropriate checks to ensure the user has permission to upload
docs to the project). But because that does not exist yet, we muss pass it as
a manual parameter.

