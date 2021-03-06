require 'open-uri'

module Themes::Portfolio::MainHelper
  def self.included(klass)
    #klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  def portfolio_settings(theme)
    # here your code on save settings for current site, by default params[:theme_fields] is auto saved into theme
    # Also, you can save your extra values added in admin/settings.html.erb
    # sample: theme.set_meta("my_key", params[:my_value])
    PluginRoutes.system_info[:skip_format_url]=true
  end

  def portfolio_on_install_theme(theme)
    unless theme.get_field_groups.where(slug: "fields").any?
      group = theme.add_field_group({name: "Main Settings", slug: "fields", description: ""})
      group.add_field({"name"=>"Background color", "slug"=>"bg_color"},{field_key: "colorpicker"})
      group.add_field({"name"=>"Links color", "slug"=>"links_color"},{field_key: "colorpicker"})
      group.add_field({"name"=>"Backgroun image", "slug"=>"bg"},{field_key: "image"})
    end
    theme.set_meta("installed_at", Time.now.to_s) # save a custom value
  end

  def portfolio_on_uninstall_theme(theme)
    theme.destroy
  end

  def after_post_save(params)
    # post = params[:post].decorate
    # post_type = params[:post_type].decorate
  end

  def on_render_sitemap(r)
    r[:skip_tag_ids] =  PostTag.all.pluck(:id)
    r[:skip_post_ids] =  PostType.find_by(slug:'event').posts.pluck(:id)
    r[:skip_posttype_ids] = PostType.all.pluck(:id)
    r[:skip_cat_ids] = Category.all.pluck(:id)
    return r
  end
end