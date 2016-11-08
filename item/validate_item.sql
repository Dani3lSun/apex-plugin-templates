FUNCTION validate_item(p_item   IN apex_plugin.t_page_item,
                       p_plugin IN apex_plugin.t_plugin,
                       p_value  IN VARCHAR2)
  RETURN apex_plugin.t_page_item_validation_result IS
  -- custom plugin attributes
  l_result apex_plugin.t_page_item_validation_result;
  -- other vars
  l_format_mask p_item.format_mask%TYPE := p_item.format_mask;
  --
BEGIN
  -- No value then nothing to do
  IF p_value IS NULL THEN
    RETURN l_result;
  END IF;
  -- Check if value is a valid date
  IF NOT wwv_flow_utilities.is_date(p_date   => p_value,
                                    p_format => l_format_mask) THEN
    l_result.message := '#LABEL# invalid date';
    RETURN l_result;
  END IF;
  --
  RETURN l_result;
  --
END validate_item;