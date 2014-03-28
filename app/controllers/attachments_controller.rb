class AttachmentsController < ApplicationController
  def show
    @attachment = Attachment.find(params[:id])
    send_file @attachment.filename,
      disposition: 'inline',
      filename: @attachment.name,
      type: @attachment.content_type
  end
end
