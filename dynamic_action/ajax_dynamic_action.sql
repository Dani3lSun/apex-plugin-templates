FUNCTION ajax_dynamic_action(p_dynamic_action IN apex_plugin.t_dynamic_action,
                             p_plugin         IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_dynamic_action_ajax_result IS
  -- plugin attributes
  l_result apex_plugin.t_dynamic_action_ajax_result;
  -- other vars
  l_value_01 VARCHAR2(100);
  l_value_02 VARCHAR2(100);
  --
BEGIN
  -- Get Data from AJAX Call
  l_value_01 := apex_application.g_x01;
  l_value_02 := apex_application.g_x02;
  -- insert values into table
  INSERT INTO my_table
    (my_table_pk,
     column_01,
     column_02)
  VALUES
    (seq_pk.nextval,
     l_value_01,
     l_value_02);
  --
  RETURN l_result;
  --
END ajax_dynamic_action;