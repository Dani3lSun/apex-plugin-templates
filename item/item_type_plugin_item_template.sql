set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.4.00.12'
,p_default_workspace_id=>42937890966776491
,p_default_application_id=>600
,p_default_owner=>'APEX_PLUGIN'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/com_mycompany_item_template
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(63820907288923354)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.MYCOMPANY.ITEM_TEMPLATE'
,p_display_name=>'Item Plug-in Template'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'FUNCTION render_item(p_item                IN apex_plugin.t_page_item,',
'                     p_plugin              IN apex_plugin.t_plugin,',
'                     p_value               IN VARCHAR2,',
'                     p_is_readonly         IN BOOLEAN,',
'                     p_is_printer_friendly IN BOOLEAN)',
'  RETURN apex_plugin.t_page_item_render_result IS',
'  -- custom plugin attributes',
'  l_result  apex_plugin.t_page_item_render_result;',
'  l_attr_01 p_item.attribute_01%TYPE := p_item.attribute_01;',
'  l_attr_02 p_item.attribute_01%TYPE := p_item.attribute_02;',
'  -- other vars',
'  l_name            VARCHAR2(30);',
'  l_escaped_value   VARCHAR2(4000);',
'  l_html_string     VARCHAR2(2000);',
'  l_element_item_id VARCHAR2(200);',
'  --',
'BEGIN',
'  -- printer friendly display',
'  IF p_is_printer_friendly THEN',
'    apex_plugin_util.print_display_only(p_item_name        => p_item.name,',
'                                        p_display_value    => p_value,',
'                                        p_show_line_breaks => FALSE,',
'                                        p_escape           => TRUE,',
'                                        p_attributes       => p_item.element_attributes);',
'    -- read only display',
'  ELSIF p_is_readonly THEN',
'    apex_plugin_util.print_hidden_if_readonly(p_item_name           => p_item.name,',
'                                              p_value               => p_value,',
'                                              p_is_readonly         => p_is_readonly,',
'                                              p_is_printer_friendly => p_is_printer_friendly);',
'    -- Normal Display',
'  ELSE',
'    l_element_item_id := p_item.name;',
'    l_name            := apex_plugin.get_input_name_for_page_item(FALSE);',
'    l_escaped_value   := apex_escape.html(p_value);',
'    --',
'    -- build input html string',
'    l_html_string := ''<input type="text" '';',
'    l_html_string := l_html_string || ''name="'' || l_name || ''" '';',
'    l_html_string := l_html_string || ''id="'' || l_element_item_id || ''" '';',
'    l_html_string := l_html_string || ''value="'' || l_escaped_value || ''" '';',
'    l_html_string := l_html_string || ''size="'' || p_item.element_width || ''" '';',
'    l_html_string := l_html_string || ''maxlength="'' ||',
'                     p_item.element_max_length || ''" '';',
'    l_html_string := l_html_string || ''attr1="'' || l_attr_01 || ''" '';',
'    l_html_string := l_html_string || ''attr2="'' || l_attr_02 || ''" '';',
'    l_html_string := l_html_string || '' '' || p_item.element_attributes ||',
'                     '' />'';',
'    --',
'    -- add JavaScript files',
'    apex_javascript.add_library(p_name           => ''my_javascript_file'',',
'                                p_directory      => p_plugin.file_prefix ||',
'                                                    ''js/'',',
'                                p_version        => NULL,',
'                                p_skip_extension => FALSE);',
'    --',
'    -- add CSS files',
'    apex_css.add_file(p_name      => ''my_css_file'',',
'                      p_directory => p_plugin.file_prefix || ''css/'');',
'    --',
'    -- add Onload Code',
'    apex_javascript.add_onload_code(p_code => ''myPlgNamespace.myItemFunction('' ||',
'                                              apex_javascript.add_value(l_element_item_id) || ''{'' ||',
'                                              apex_javascript.add_attribute(''attr1'',',
'                                                                            l_attr_01) ||',
'                                              apex_javascript.add_attribute(''attr2'',',
'                                                                            l_attr_02,',
'                                                                            FALSE,',
'                                                                            FALSE) ||',
'                                              ''});'');',
'    -- write item html',
'    htp.p(l_html_string);',
'  END IF;',
'  --',
'  l_result.is_navigable := TRUE;',
'  RETURN l_result;',
'  --',
'END render_item;',
'',
'FUNCTION ajax_item(p_item   IN apex_plugin.t_page_item,',
'                   p_plugin IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_page_item_ajax_result IS',
'  --',
'  -- plugin attributes',
'  l_result    apex_plugin.t_page_item_ajax_result;',
'  l_sql_query p_item.lov_definition%TYPE := p_item.lov_definition;',
'  -- vars for sql query parse and json write',
'  l_data_type_list    apex_application_global.vc_arr2;',
'  l_column_value_list apex_plugin_util.t_column_value_list2;',
'  l_row_count         NUMBER;',
'  --',
'BEGIN',
'  -- Data Types of SQL Source Columns',
'  l_data_type_list(1) := apex_plugin_util.c_data_type_varchar2;',
'  l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;',
'  -- Get Data from SQL Source',
'  l_column_value_list := apex_plugin_util.get_data2(p_sql_statement  => l_sql_query,',
'                                                    p_min_columns    => 2,',
'                                                    p_max_columns    => 2,',
'                                                    p_component_name => p_item.name);',
'  -- loop over SQL Source results and write json',
'  apex_json.open_object;',
'  apex_json.open_array(''myarray'');',
'  -- ',
'  l_row_count := l_column_value_list(1).value_list.count;',
'  --',
'  FOR i IN 1 .. l_row_count LOOP',
'    apex_json.open_object;',
'    apex_json.write(''element1'',',
'                    l_column_value_list(1).value_list(i).varchar2_value);',
'    apex_json.write(''element2'',',
'                    l_column_value_list(2).value_list(i).varchar2_value);',
'    apex_json.close_object;',
'  END LOOP;',
'  --',
'  apex_json.close_array;',
'  apex_json.close_object;',
'  --',
'  RETURN l_result;',
'  --',
'END ajax_item;',
'',
'FUNCTION validate_item(p_item   IN apex_plugin.t_page_item,',
'                       p_plugin IN apex_plugin.t_plugin,',
'                       p_value  IN VARCHAR2)',
'  RETURN apex_plugin.t_page_item_validation_result IS',
'  -- custom plugin attributes',
'  l_result apex_plugin.t_page_item_validation_result;',
'  -- other vars',
'  l_format_mask p_item.format_mask%TYPE := p_item.format_mask;',
'  --',
'BEGIN',
'  -- No value then nothing to do',
'  IF p_value IS NULL THEN',
'    RETURN l_result;',
'  END IF;',
'  -- Check if value is a valid date',
'  IF NOT wwv_flow_utilities.is_date(p_date   => p_value,',
'                                    p_format => l_format_mask) THEN',
'    l_result.message := ''#LABEL# invalid date'';',
'    RETURN l_result;',
'  END IF;',
'  --',
'  RETURN l_result;',
'  --',
'END validate_item;'))
,p_render_function=>'render_item'
,p_ajax_function=>'ajax_item'
,p_validation_function=>'validate_item'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63821157737925313)
,p_plugin_id=>wwv_flow_api.id(63820907288923354)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Attribute 01'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63821433273925717)
,p_plugin_id=>wwv_flow_api.id(63820907288923354)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Attribute 02'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
