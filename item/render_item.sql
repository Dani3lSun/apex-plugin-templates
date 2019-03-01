FUNCTION render_item(p_item                IN apex_plugin.t_page_item,
                     p_plugin              IN apex_plugin.t_plugin,
                     p_value               IN VARCHAR2,
                     p_is_readonly         IN BOOLEAN,
                     p_is_printer_friendly IN BOOLEAN)
  RETURN apex_plugin.t_page_item_render_result IS
  -- custom plugin attributes
  l_result  apex_plugin.t_page_item_render_result;
  l_attr_01 p_item.attribute_01%TYPE := p_item.attribute_01;
  l_attr_02 p_item.attribute_01%TYPE := p_item.attribute_02;
  -- other vars
  l_name            VARCHAR2(30);
  l_escaped_value   VARCHAR2(4000);
  l_html_string     VARCHAR2(2000);
  l_element_item_id VARCHAR2(200);
  --
BEGIN    
  -- pass debug information to APEX framework
  if apex_application.g_debug then
      apex_plugin_util.debug_page_item (
          p_plugin              => p_plugin,
          p_page_item           => p_item,
          p_value               => p_value,
          p_is_readonly         => p_is_readonly,
          p_is_printer_friendly => p_is_printer_friendly );
  end if;
  --
  -- printer friendly display
  IF p_is_printer_friendly THEN
    apex_plugin_util.print_display_only(p_item_name        => p_item.name,
                                        p_display_value    => p_value,
                                        p_show_line_breaks => FALSE,
                                        p_escape           => TRUE,
                                        p_attributes       => p_item.element_attributes);
    -- read only display
  ELSIF p_is_readonly THEN
    apex_plugin_util.print_hidden_if_readonly(p_item_name           => p_item.name,
                                              p_value               => p_value,
                                              p_is_readonly         => p_is_readonly,
                                              p_is_printer_friendly => p_is_printer_friendly);
    -- Normal Display
  ELSE
    l_element_item_id := p_item.name;
    l_name            := apex_plugin.get_input_name_for_page_item(FALSE);
    l_escaped_value   := apex_escape.html(p_value);
    --
    -- build input html string
    l_html_string := '<input type="text" ';
    l_html_string := l_html_string || 'name="' || l_name || '" ';
    l_html_string := l_html_string || 'id="' || l_element_item_id || '" ';
    l_html_string := l_html_string || 'value="' || l_escaped_value || '" ';
    l_html_string := l_html_string || 'size="' || p_item.element_width || '" ';
    l_html_string := l_html_string || 'maxlength="' ||
                     p_item.element_max_length || '" ';
    l_html_string := l_html_string || 'attr1="' || l_attr_01 || '" ';
    l_html_string := l_html_string || 'attr2="' || l_attr_02 || '" ';
    l_html_string := l_html_string || ' ' || p_item.element_attributes ||
                     ' />';
    --
    -- add JavaScript files
    apex_javascript.add_library(p_name           => 'my_javascript_file',
                                p_directory      => p_plugin.file_prefix ||
                                                    'js/',
                                p_version        => NULL,
                                p_skip_extension => FALSE);
    --
    -- add CSS files
    apex_css.add_file(p_name      => 'my_css_file',
                      p_directory => p_plugin.file_prefix || 'css/');
    --
    -- add Onload Code
    apex_javascript.add_onload_code(p_code => 'myPlgNamespace.myItemFunction(' ||
                                              apex_javascript.add_value(l_element_item_id) || '{' ||
                                              apex_javascript.add_attribute('attr1',
                                                                            l_attr_01) ||
                                              apex_javascript.add_attribute('attr2',
                                                                            l_attr_02,
                                                                            FALSE,
                                                                            FALSE) ||
                                              '});');
    -- write item html
    htp.p(l_html_string);
  END IF;
  --
  l_result.is_navigable := TRUE;
  RETURN l_result;
  --
END render_item;
