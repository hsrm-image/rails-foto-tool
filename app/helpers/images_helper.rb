module ImagesHelper
    def image_size(variant, opts = {})
        if variant.processed?
            variant.processed.send(:record).image.blob.analyze unless variant.processed.send(:record).image.blob.analyzed?
            metadata = variant.processed.send(:record).image.blob.metadata
            if metadata['width']
                opts[:width] = metadata['width']
                opts[:height] = metadata['height']
            end
        end
        return opts
    end

end
