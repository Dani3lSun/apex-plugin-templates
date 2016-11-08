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
prompt --application/shared_components/plugins/dynamic_action/com_mycompany_dynamic_action_template
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(63822646771955963)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.MYCOMPANY.DYNAMIC_ACTION_TEMPLATE'
,p_display_name=>'Dynamic Action Plug-in Template'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'FUNCTION render_dynamic_action(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                               p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result IS',
'  --',
'  -- plugin attributes',
'  l_result  apex_plugin.t_dynamic_action_render_result;',
'  l_attr_01 p_dynamic_action.attribute_01%TYPE := p_dynamic_action.attribute_01;',
'  l_attr_02 p_dynamic_action.attribute_02%TYPE := p_dynamic_action.attribute_02;',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'  -- add JavaScript files',
'  apex_javascript.add_library(p_name           => ''my_javascript_file'',',
'                              p_directory      => p_plugin.file_prefix ||',
'                                                  ''js/'',',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
'  --',
'  -- add CSS files',
'  apex_css.add_file(p_name      => ''my_css_file'',',
'                    p_directory => p_plugin.file_prefix || ''css/'');',
'  --',
'  --',
'  l_result.javascript_function := ''myPlgNamespace.myDaFunction'';',
'  l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;',
'  l_result.attribute_01        := l_attr_01;',
'  l_result.attribute_02        := l_attr_02;',
'  --',
'  RETURN l_result;',
'  --',
'END render_dynamic_action;',
'',
'FUNCTION ajax_dynamic_action(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                             p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_ajax_result IS',
'  -- plugin attributes',
'  l_result apex_plugin.t_dynamic_action_ajax_result;',
'  -- other vars',
'  l_value_01 VARCHAR2(100);',
'  l_value_02 VARCHAR2(100);',
'  --',
'BEGIN',
'  -- Get Data from AJAX Call',
'  l_value_01 := apex_application.g_x01;',
'  l_value_02 := apex_application.g_x02;',
'  -- insert values into table',
'  /*INSERT INTO my_table',
'    (my_table_pk,',
'     column_01,',
'     column_02)',
'  VALUES',
'    (seq_pk.nextval,',
'     l_value_01,',
'     l_value_02);*/',
'  --',
'  RETURN l_result;',
'  --',
'END ajax_dynamic_action;'))
,p_render_function=>'render_dynamic_action'
,p_ajax_function=>'ajax_dynamic_action'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63822898456958155)
,p_plugin_id=>wwv_flow_api.id(63822646771955963)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Attribute 01'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63823158309958502)
,p_plugin_id=>wwv_flow_api.id(63822646771955963)
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
