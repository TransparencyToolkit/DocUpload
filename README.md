This is a simple document upload form. To use-

1. Ensure you have sinatra, gpgme, pry, and dock_integrity_check installed

2. In config.ru, set the gpg_recipient key ID to the GPG key on the OCR
server. Set the gpg_signer to the key ID on this sever.

3. Set the ocrserver_url and lookingglass_url in the config.ru file

4. In this directory, run: rackup config.ru

5. Go to http://localhost:9292/upload/archive_test in your browser

Note that "archive_test" determines the project spec (and index where the data
is saved). The project spec parameter should match the config variable in the
LookingGlass initializer.


