FUNCTION render_dynamic_action(p_dynamic_action IN apex_plugin.t_dynamic_action,
                               p_plugin         IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_dynamic_action_render_result IS
  --
  -- plugin attributes
  l_result  apex_plugin.t_dynamic_action_render_result;
  l_attr_01 p_dynamic_action.attribute_01%TYPE := p_dynamic_action.attribute_01;
  l_attr_02 p_dynamic_action.attribute_02%TYPE := p_dynamic_action.attribute_02;
  --
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,
                                          p_dynamic_action => p_dynamic_action);
  END IF;
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
  --
  l_result.javascript_function := 'myPlgNamespace.myDaFunction';
  l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;
  l_result.attribute_01        := l_attr_01;
  l_result.attribute_02        := l_attr_02;
  --
  RETURN l_result;
  --
END render_dynamic_action;