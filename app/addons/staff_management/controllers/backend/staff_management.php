<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']	== 'POST') {
    fn_trusted_vars('staff_management', 'staff_data');
    $suffix = '';

    if ($mode == 'm_delete') {
        foreach ($_REQUEST['staff_ids'] as $v) {
            fn_delete_staff_by_id($v);
        }
        $suffix = '.manage';
    }

    if ($mode == 'update') {
        $staff_id = fn_update_staff($_REQUEST['staff_data'], $_REQUEST['staff_id']);

        $suffix = ".update?staff_id=$staff_id";
    }

    if ($mode == 'delete') {
        if (!empty($_REQUEST['staff_id'])) {
            fn_delete_staff_by_id($_REQUEST['staff_id']);
        }

        $suffix = '.manage';
    }

    return array(CONTROLLER_STATUS_OK, 'staff_management' . $suffix);
}

if ($mode == 'update') {
    $staff_members = fn_get_staff_data($_REQUEST['staff_id']);

    if (empty($staff_members)) {
        return array(CONTROLLER_STATUS_NO_PAGE);
    }

    Registry::set('navigation.tabs', array (
        'general' => array (
            'title' => __('general'),
            'js' => true
        ),
    ));

    Tygh::$app['view']->assign('staff_members', $staff_members);

} elseif ($mode == 'manage') {

    list($staff_members, $params) = fn_get_staff_members($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

    Tygh::$app['view']->assign(array(
        'staff_members'  => $staff_members,
        'search' => $params,
    ));
}

