class UserpanelsController < ApplicationController
    def index
    end

    def show_images
        respond_to do |format|
            format.js{}
          end
    end
    def show_collections
        respond_to do |format|
            format.js{}
          end
    end
end
