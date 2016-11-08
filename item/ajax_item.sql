FUNCTION ajax_item(p_item   IN apex_plugin.t_page_item,
                   p_plugin IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_page_item_ajax_result IS
  --
  -- plugin attributes
  l_result    apex_plugin.t_page_item_ajax_result;
  l_sql_query p_item.lov_definition%TYPE := p_item.lov_definition;
  -- vars for sql query parse and json write
  l_data_type_list    apex_application_global.vc_arr2;
  l_column_value_list apex_plugin_util.t_column_value_list2;
  l_row_count         NUMBER;
  --
BEGIN
  -- Data Types of SQL Source Columns
  l_data_type_list(1) := apex_plugin_util.c_data_type_varchar2;
  l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;
  -- Get Data from SQL Source
  l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => l_sql_query,
                                                    p_min_columns    => 2,
                                                    p_max_columns    => 2,
                                                    p_component_name => p_item.name);
  -- loop over SQL Source results and write json
  apex_json.open_object;
  apex_json.open_array('myarray');
  -- 
  l_row_count := l_column_value_list(1).value_list.count;
  --
  FOR i IN 1 .. l_row_count LOOP
    apex_json.open_object;
    apex_json.write('element1',
                    l_column_value_list(1).value_list(i).varchar2_value);
    apex_json.write('element2',
                    l_column_value_list(2).value_list(i).varchar2_value);
    apex_json.close_object;
  END LOOP;
  --
  apex_json.close_array;
  apex_json.close_object;
  --
  RETURN l_result;
  --
END ajax_item;