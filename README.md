# README

Please run this command to change your credentials, substitute "\<editor\>" with your preferred text editor. If you want to use vs code for example, use: "code --wait"

    EDITOR="<editor>" rails credentials:edit

This file should have the following format:

    minio:
      access_key_id: xxx
      secret_access_key: xxx

    mailer:
      user_name: mmueller
      password: xxx

    # https://developers.google.com/maps/documentation/embed/get-api-key 
    maps_api:
      key: xxx

    secret_key_base: xxx

The mailer is currently setup to use the mailing service provided by UAS RheinMain. Please edit config/environments/... to change this behaviour.

The maps key is not required. If no maps key is set, the image description will display the coordinates of the image.

Then edit the file

    config/application.rb


Finally you can run

    rails db:migrate

or

    rake db:migrate:reset

To create the Database.
The server can now be run using

    rails s -p <port> -b 0.0.0.0

A User with the credentials webmaster@localhost.com:administrator will be created as the default user. (Defined in db/seeds.rb)

System tests should be performed independently of the other tests, because they require a session id.

To run all exept for system tests:

    rails test

to run system tests:

    rails test test/system

PLEASE CHANGE THIS IMMIDIATELY!!!




if no images appear on /images, please stop the server an run

Image.all.each { |x| AnalyseImageJob.perform_later x}

in "rails console"

after that you can use 

Image.all.each { |x| puts x.id unless x.processed}

to see all hidden images and re-analyse/delete them manually