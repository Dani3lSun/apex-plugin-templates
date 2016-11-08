FUNCTION ajax_region(p_region IN apex_plugin.t_region,
                     p_plugin IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_region_ajax_result IS
  -- plugin attributes
  l_result apex_plugin.t_region_ajax_result;
  l_plsql  p_region.attribute_03%TYPE := p_region.attribute_03;
  --
BEGIN
  -- execute PL/SQL
  apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql);
  --
  RETURN l_result;
  --
END ajax_region;