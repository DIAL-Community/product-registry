# frozen_string_literal: true

class FroalaImagesController < ApplicationController
  def upload
    # The Model: FroalaImage, created below.

    @froala_image = FroalaImage.new
    @froala_image.picture = params[:file]
    @froala_image.save

    respond_to do |format|
      format.json { render(json: { status: 'OK', link: @froala_image.picture.url }) }
    end
  end
end
