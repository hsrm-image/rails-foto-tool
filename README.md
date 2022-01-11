# README

Please run this command to change your credentials

    EDITOR="code --wait" rails credentials:edit

Then edit the file

    config/application.rb


Finally you can run

    rails db:migrate

or

    rake db:migrate:reset

To create the Database.
The server can now be run using

    rails s -p <port> -b 0.0.0.0

A User with the credentials webmaster@localhost.com:administrator will be created as the default user.

PLEASE CHANGE THIS IMMIDIATELY!!!




if no images appear on /images, please stop the server an run

Image.all.each { |x| AnalyseImageJob.perform_later x}

in "rails console"

after that you can use 

Image.all.each { |x| puts x.id unless x.processed}

to see all hidden images and re-analyse/delete them manually