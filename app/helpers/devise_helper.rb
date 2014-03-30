module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    html = ''
    resource.errors.full_messages.each do |msg|
      html += flash_error msg
    end
    html.html_safe
  end

  private

  def flash_error(msg)
    html = <<-HTML
    <div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert">
        &times;
      </button>
      #{msg}
    </div>
    HTML
    html
  end
end
