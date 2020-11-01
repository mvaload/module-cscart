{** staff_members section **}

{capture name="mainbox"}
<form action="{""|fn_url}" method="post" name="staff_members_form" class=" cm-hide-inputs" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />
{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_contents_staff_members"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

{assign var="rev" value=$smarty.request.content_id|default:"pagination_contents_staff_members"}
{assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}

{if $staff_members}
<div class="table-responsive-wrapper">
    <table class="table table-middle table--relative table-responsive">
    <thead>
    <tr>
        <th width="1%" class="left mobile-hide">{include file="common/check_items.tpl" class="cm-no-hide-input"}</th>
        <th class="left mobile-hide" width="7%">{__("position_short")}</th>
        <th>Name</th>
        {hook name="staff_management:manage_header"}
        {/hook}
        <th width="6%" class="mobile-hide">&nbsp;</th>
        <th width="10%" class="right">{__("status")}</th>
    </tr>
    </thead>
    {foreach from=$staff_members item=staff}
    <tr class="cm-row-status-{$staff.status|lower}">
        {assign var="allow_save" value=$staff|fn_allow_save_object:"staff_members"}

        {if $allow_save}
            {assign var="no_hide_input" value="cm-no-hide-input"}
        {else}
            {assign var="no_hide_input" value=""}
        {/if}

        <td class="left mobile-hide">
            <input type="checkbox" name="staff_ids[]" value="{$staff.staff_id}" class="cm-item {$no_hide_input}" /></td>

        <td width="7%" class="mobile-hide" data-th="{__("position_short")}">{$staff.position}</td>

        <td class="{$no_hide_input}" data-th="{__("staff")}">
            <a class="row-status" href="{"staff_management.update?staff_id=`$staff.staff_id`"|fn_url}">{$staff.last_name} {$staff.first_name}</a>
        </td>

        <td class="mobile-hide">
            {capture name="tools_list"}
                <li>{btn type="list" text=__("edit") href="staff_management.update?staff_id=`$staff.staff_id`"}</li>
            {if $allow_save}
                <li>{btn type="list" class="cm-confirm" text=__("delete") href="staff_management.delete?staff_id=`$staff.staff_id`" method="POST"}</li>
            {/if}
            {/capture}
            <div class="hidden-tools">
                {dropdown content=$smarty.capture.tools_list}
            </div>
        </td>
        <td class="right" data-th="{__("status")}">
            {include file="common/select_popup.tpl" id=$staff.staff_id status=$staff.status hidden=true object_id_name="staff_id" table="staff_members" popup_additional_class="`$no_hide_input` dropleft"}
        </td>
    </tr>
    {/foreach}
    </table>
</div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_contents_staff_members"}

{capture name="buttons"}
    {capture name="tools_list"}
        {if $staff_members}
            <li>{btn type="delete_selected" dispatch="dispatch[staff_management.m_delete]" form="staff_members_form"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list class="mobile-hide"}
{/capture}
{capture name="adv_buttons"}
    {hook name="staff_management:adv_buttons"}
    {include file="common/tools.tpl" tool_href="staff_management.add" prefix="top" hide_tools="true" title=__("add_staff_members") icon="icon-plus"}
    {/hook}
{/capture}

</form>

{/capture}

{hook name="staff_management:manage_mainbox_params"}
    {$page_title = __("staff_members")}
    {$select_languages = true}
{/hook}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=$select_languages sidebar=$smarty.capture.sidebar}

{** ad section **}