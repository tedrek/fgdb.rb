<?php
require_once 'api/v2/utils.php';
/**
 * See if a CiviCRM custom field group exists
 *
 * @param string $group_name
 *   custom field group name to look for, corresponds to field civicrm_custom_group.name
 * @return integer
 *   custom field group id if it exists, else zero
 */
function civicrm_custom_get_group_id(&$params) {
  $group_name = $params['group_name'];
  $result = 0;

  // This is an empty array we pass in to make the retrieve() function happy
  $def = array();
  $params = array(
    'name' => $group_name,
  );

  require_once('CRM/Core/BAO/CustomGroup.php');

  $custom_group = CRM_Core_BAO_CustomGroup::retrieve($params, $def);

  if (!empty($custom_group)) {
    $result = $custom_group->id;
  }
  return $result;
}


/**
 * See if a CiviCRM custom field exists
 *
 * @param integer $custom_group_id
 *   custom group id that the field is expected to belong to
 * @param string $field_label
 *   custom field name to look for, corresponds to field civicrm_custom_field.label
 * @return integer
 *   custom field id if it exists, else zero
 */
function civicrm_custom_get_field_id(&$params) {
  $custom_group_id = $params['group_id'];
  $field_label = $params['field_name'];
  $result = 0;

  // This is an empty array we pass in to make the retrieve() function happy
  $def = array();
  $params = array(
    'custom_group_id' => $custom_group_id,
    'label'           => $field_label,
  );

  require_once('CRM/Core/BAO/CustomField.php');

  $custom_field = CRM_Core_BAO_CustomField::retrieve($params, $def);

  if (!empty($custom_field)) {
    $result = $custom_field->id;
  }
  return $result;
}
