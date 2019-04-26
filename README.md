This is a simple document upload form for use with Transpareny Toolkit's tools.

## Instructions

1. Ensure you have sinatra, curb, and pry installed

2. The following environment variables need to be set (in config.ru or otherwise):

   * LOOKINGGLASS_URL: URL to reach LookingGlass
   * OCR_IN_PATH: Directory path files should save at for the OCR server to read
   * OCR_OUT_PATH: Directory path OCRed data will be saved at
   * ARCHIVEADMIN_URL: The URL to the archive admin system (for access verification
   * PROJECT_INDEX: The index name for the archive
   * ARCHIVE_SECRET_KEY: The secret key for the archive.

3. In this directory, run: rackup config.ru

4. Go to http://localhost:9292 in your browser



