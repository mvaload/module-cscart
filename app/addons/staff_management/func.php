<?php

use Tygh\BlockManager\Block;
use Tygh\Tools\SecurityHelper;

if (!defined('BOOTSTRAP')) { die('Access denied'); }


function fn_get_staff_members($params = array(), $items_per_page = 0)
{
    $default_params = array(
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    $sortings = array(
        'position' => '?:staff_members.position',
    );

    $condition = $limit = '';

    if (!empty($params['limit'])) {
        $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
    }

    $sorting = db_sort($params, $sortings, 'position', 'asc');

    if (!empty($params['item_ids'])) {
        $condition .= db_quote(' AND ?:staff_members.staff_id IN (?n)', explode(',', $params['item_ids']));
    }

    $fields = array (
        '?:staff_members.staff_id',
        '?:staff_members.first_name',
        '?:staff_members.last_name',
        '?:staff_members.function',
        '?:staff_members.email',
        '?:staff_members.description',
        '?:staff_members.position',
        '?:staff_members.status',
    );

    /**
     * This hook allows you to change parameters of the staff selection before making an SQL query.
     *
     * @param array        $params    The parameters of the user's query (limit, period, item_ids, etc)
     * @param string       $condition The conditions of the selection
     * @param string       $sorting   Sorting (ask, desc)
     * @param string       $limit     The LIMIT of the returned rows
     * @param array        $fields    Selected fields
     */
    fn_set_hook('staff_members', $params, $condition, $sorting, $limit, $fields);

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:staff_members WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $staff = db_get_hash_array(
        "SELECT ?p FROM ?:staff_members " .
        "WHERE 1 ?p ?p ?p",
        'staff_id', implode(', ', $fields), $condition, $sorting, $limit
    );

    if (!empty($params['item_ids'])) {
        $staff = fn_sort_by_ids($staff, explode(',', $params['item_ids']), 'staff_id');
    }

    fn_set_hook('staff_members_post', $staff, $params);

    return array($staff, $params);
}


function fn_get_staff_data($staff_id)
{
    $fields = array();
    $condition = '';

    $fields = array (
        '?:staff_members.staff_id',
        '?:staff_members.first_name',
        '?:staff_members.last_name',
        '?:staff_members.function',
        '?:staff_members.email',
        '?:staff_members.description',
        '?:staff_members.position',
        '?:staff_members.status',
    );

    $condition = db_quote("WHERE ?:staff_members.staff_id = ?i", $staff_id);

    /**
     * Prepare params for staff_members data SQL query
     *
     * @param int   $staff_id Staff ID
     * @param array $fields    Fields list
     * @param str   $condition Conditions query
     */
    fn_set_hook('get_staff_data', $staff_id, $fields, $condition);

    $staff = db_get_row("SELECT " . implode(", ", $fields) . " FROM ?:staff_members " . " $condition");


    /**
     * Post processing of staff_members data
     *
     * @param int   $staff_id Staff ID
     * @param array $staff    Staff data
     */
    fn_set_hook('get_staff_data_post', $staff_id, $staff);

    return $staff;
}

function fn_update_staff($data, $staff_id)
{
    SecurityHelper::sanitizeObjectData('staff', $data);

    if (isset($data['timestamp'])) {
        $data['timestamp'] = fn_parse_date($data['timestamp']);
    }
    $data['localization'] = empty($data['localization']) ? '' : fn_implode_localizations($data['localization']);

    if (!empty($staff_id)) {
        db_query("UPDATE ?:staff_members SET ?u WHERE staff_id = ?i", $data, $staff_id);

    } else {
        $staff_id = $data['staff_id'] = db_query("REPLACE INTO ?:staff_members ?e", $data);

    }
    return $staff_id;
}

function fn_delete_staff_by_id($staff_id)
{
    if (!empty($staff_id) && fn_check_company_id('staff_members', 'staff_id', $staff_id)) {
        db_query("DELETE FROM ?:staff_members WHERE staff_id = ?i", $staff_id);
        fn_set_hook('delete_staff_members', $staff_id);
        Block::instance()->removeDynamicObjectData('staff_members', $staff_id);
    }
}
