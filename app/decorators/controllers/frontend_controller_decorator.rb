FrontendController.class_eval do
  def page_not_found()
    if @_site_options[:error_404].present? # render a custom error page
      page_404 = current_site.posts.find(@_site_options[:error_404]) rescue ""
      if page_404.present?
        page_404 = page_404.decorate
        redirect_to page_404.the_url
        return
      end
    end
    render_error(404)
  end
end
