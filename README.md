# README

Please run 

rake db:migrate:reset

if no images appear on /images, please stop the server an run

Image.all.each { |x| AnalyseImageJob.perform_later x}

in "rails console"

after that you can use 

Image.all.each { |x| puts x.id unless x.processed}

to see all hidden images and re-analyse/delete them manually