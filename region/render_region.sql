FUNCTION render_region(p_region              IN apex_plugin.t_region,
                       p_plugin              IN apex_plugin.t_plugin,
                       p_is_printer_friendly IN BOOLEAN)
  RETURN apex_plugin.t_region_render_result IS
  -- plugin attributes
  l_result  apex_plugin.t_region_render_result;
  l_attr_01 p_region.attribute_01%TYPE := p_region.attribute_01;
  l_attr_02 p_region.attribute_02%TYPE := p_region.attribute_02;
  -- other vars
  l_region_id VARCHAR2(200);
  --
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_region(p_plugin => p_plugin,
                                  p_region => p_region);
  END IF;
  -- set vars
  l_region_id := apex_escape.html_attribute(p_region.static_id ||
                                            '_myregion');
  -- escape input
  l_attr_01 := apex_escape.html(l_attr_01);
  l_attr_02 := apex_escape.html(l_attr_02);
  --
  -- write region html
  sys.htp.p('<div id="' || l_region_id ||
            '" class="my_region_class" attr1="' || l_attr_01 ||
            '" attr2="' || l_attr_02 || '"></div>');
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
  -- onload code
  apex_javascript.add_onload_code(p_code => 'myPlgNamespace.myRegionFunction(' ||
                                            apex_javascript.add_value(p_region.static_id) || '{' ||
                                            apex_javascript.add_attribute('attr1',
                                                                          l_attr_01) ||
                                            apex_javascript.add_attribute('attr2',
                                                                          l_attr_02,
                                                                          FALSE,
                                                                          FALSE) ||
                                            '});');
  --
  RETURN l_result;
  --
END render_region;
