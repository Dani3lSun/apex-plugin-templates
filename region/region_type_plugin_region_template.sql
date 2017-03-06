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
prompt --application/shared_components/plugins/region_type/com_mycompany_region_template
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(63821757402938287)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COM.MYCOMPANY.REGION_TEMPLATE'
,p_display_name=>'Region Plug-in Template'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'FUNCTION render_region(p_region              IN apex_plugin.t_region,',
'                       p_plugin              IN apex_plugin.t_plugin,',
'                       p_is_printer_friendly IN BOOLEAN)',
'  RETURN apex_plugin.t_region_render_result IS',
'  -- plugin attributes',
'  l_result  apex_plugin.t_region_render_result;',
'  l_attr_01 p_region.attribute_01%TYPE := p_region.attribute_01;',
'  l_attr_02 p_region.attribute_02%TYPE := p_region.attribute_02;',
'  -- other vars',
'  l_region_id VARCHAR2(200);',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_region(p_plugin => p_plugin,',
'                                  p_region => p_region);',
'  END IF;',
'  -- set vars',
'  l_region_id := apex_escape.html_attribute(p_region.static_id ||',
'                                            ''_myregion'');',
'  -- escape input',
'  l_attr_01 := apex_escape.html(l_attr_01);',
'  l_attr_02 := apex_escape.html(l_attr_02);',
'  --',
'  -- write region html',
'  sys.htp.p(''<div id="'' || l_region_id ||',
'            ''" class="my_region_class" attr1="'' || l_attr_01 ||',
'            ''" attr2="'' || l_attr_02 || ''"></div>'');',
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
'  -- onload code',
'  apex_javascript.add_onload_code(p_code => ''myPlgNamespace.myRegionFunction('' ||',
'                                            apex_javascript.add_value(p_region.static_id) || ''{'' ||',
'                                            apex_javascript.add_attribute(''attr1'',',
'                                                                          l_attr_01) ||',
'                                            apex_javascript.add_attribute(''attr2'',',
'                                                                          l_attr_02,',
'                                                                          FALSE,',
'                                                                          FALSE) ||',
'                                            ''});'');',
'  --',
'  RETURN l_result;',
'  --',
'END render_region;',
'',
'FUNCTION ajax_region(p_region IN apex_plugin.t_region,',
'                     p_plugin IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_region_ajax_result IS',
'  -- plugin attributes',
'  l_result apex_plugin.t_region_ajax_result;',
'  l_plsql  p_region.attribute_03%TYPE := p_region.attribute_03;',
'  --',
'BEGIN',
'  -- execute PL/SQL',
'  apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql);',
'  --',
'  RETURN l_result;',
'  --',
'END ajax_region;'))
,p_render_function=>'render_region'
,p_ajax_function=>'ajax_region'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63821949388939782)
,p_plugin_id=>wwv_flow_api.id(63821757402938287)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Attribute 01'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63822283544940084)
,p_plugin_id=>wwv_flow_api.id(63821757402938287)
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
