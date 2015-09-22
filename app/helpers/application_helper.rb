module ApplicationHelper
  # draw menu as an html
  # default configurations is for bootstrap support
  def my_draw_menu(args = {})
    args_def = {
                menu_slug:        'main_menu', #slug for the menu
                container:        'ul', #type of container for the menu
                container_id:     '', #container id for the menu
                container_class:  'nav navbar-nav nav-menu', #container class for the menu
                item_container:   'li', #type of container for the items
                item_current:     'current-menu-item', #class for current menu item
                item_class:       'menu-item', # class for all menu items
                item_class_parent:"dropdown", # class for all menu items that contain sub items
                sub_container:    'ul', #type of container for sub items
                sub_class:        'dropdown-menu', # class for sub container
                callback_item:    lambda{|args| },
                    # callback executed for each item (args = { menu_item, link, level, settings, has_children, link_attrs = "", index}).
                    #     menu_item: (Object) Menu object
                    #     link: (Hash) link data: {link: '', name: ''}
                    #     level: (Integer) current level
                    #     has_children: (boolean) if this item contain sub menus
                    #     settings: (Hash) menu settings
                    #     index: (Integer) Index Position of this menu
                    #     link_attrs: (String) Here you can add your custom attrs for current link, sample: id='my_id' data-title='#{args[:link][:name]}'
                    # In settings you can change the values for this item, like after, before, ..:
                    # sample: lambda{|args| args[:settings][:after] = "<span class='caret'></span>" if args[:has_children]; args[:link_attrs] = "id='#{menu_item.id}'";  }
                    # sample: lambda{|args| args[:settings][:before] = "<i class='fa fa-home'></i>" if args[:level] == 0 && args[:index] == 0;  }
                before:           '', # content before link text
                after:            '', # content after link text
                link_current:     'current-link', # class for current menu link
                link_before:      '', # content before link
                link_after:       '', # content after link
                link_class:       'menu_link', # class for all menu links
                link_class_parent:"dropdown-toggle", # class for all menu links that contain sub items
                levels:            -1, # max of levels to recover, -1 => return all levels
                container_prepend:      '', # content prepend for menu container
                container_append:       ''  # content append for menu container
                }

    args = args_def.merge(args)
    nav_menu = current_site.nav_menus.find_by_slug(args[:menu_slug])
    html = "<#{args[:container]} class='#{args[:container_class]}' id='#{args[:container_id]}'>#{args[:container_prepend]}{__}#{front_editor_link(admin_appearances_nav_menus_menu_url(slug: nav_menu.slug)) rescue ""}#{args[:container_append]}</#{args[:container]}>"
    if nav_menu.present?
      html = html.sub("{__}", _my_menu_draw_items(args, nav_menu.children))
    else
      html = html.sub("{__}", "")
    end
    html
  end

  # draw menu items
  def _my_menu_draw_items(args, nav_menu, level = 0)
    html = ""
    _args = args.dup
    parent_current = false
    index = 0
    nav_menu.eager_load(:metas).each do |nav_menu_item|
      data_nav_item = _get_link_nav_menu(nav_menu_item)
      next if data_nav_item == false
      _is_current = site_current_path == data_nav_item[:link] || site_current_path == data_nav_item[:link].sub(".html", "") || (current_site.the_post(current_site.options[:home_page]).the_url(as_path:true) == data_nav_item[:link] && is_home?) || (data_nav_item[:link] == current_site.the_post('projects').the_url(as_path:true) && @post_type.the_slug == 'project')
      has_children = nav_menu_item.have_children? && (args[:levels] == -1 || (args[:levels] != -1 && level <= args[:levels]))
      r = { menu_item: nav_menu_item, link: data_nav_item, level: level, settings: _args, has_children: has_children, link_attrs: '', index: index}; args[:callback_item].call(r);
      _args = r[:settings]

      if has_children
        html_children, current_children = _my_menu_draw_items(args, nav_menu_item.children, level + 1)
      else
        html_children, current_children = "", false
      end
      parent_current = true if _is_current || current_children

      html += "<#{_args[:item_container]} class='#{_args[:item_class]} #{_args[:item_class_parent] if has_children} #{"#{_args[:item_current]}" if _is_current} #{"current-menu-ancestor" if current_children }'>#{_args[:link_before]}
                <a #{r[:link_attrs]} href='#{data_nav_item[:link]}' class='#{args[:link_current] if _is_current} #{_args[:link_class_parent] if has_children} #{_args[:link_class]}' >#{_args[:before]}#{data_nav_item[:name]}#{_args[:after]}</a> #{_args[:link_after]}
                #{ html_children }
              </#{_args[:item_container]}>"
      index += 1
    end

    if level == 0
      html
    else
      html = "<#{_args[:sub_container]} class='#{_args[:sub_class]} #{"parent-#{args[:item_current]}" if parent_current} level-#{level}'>#{html}</#{_args[:sub_container]}>"
      [html, parent_current]
    end
  end

  def bgCover(image_url)
    "background-image: url('#{image_url}');-webkit-background-size: cover;-moz-background-size: cover;-o-background-size: cover;background-size: cover; background-position: center center; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'#{image_url}\', sizingMethod=\'scale\'); -ms-filter: 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'#{image_url}\', sizingMethod=\'scale\')';"
  end
end
