{if $staff_members}
    {assign var="id" value=$staff_members.staff_id}
{else}
    {assign var="id" value=0}
{/if}


{** staff section **}

{$allow_save = $staff_members|fn_allow_save_object:"staff_members"}
{$hide_inputs = ""|fn_check_form_permissions}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit{if !$allow_save || $hide_inputs} cm-hide-inputs{/if}" name="staff_members_form" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
<input type="hidden" class="cm-no-hide-input" name="staff_id" value="{$id}" />

{capture name="tabsbox"}

    <div id="content_general">
        {hook name="staff_management:general_content"}
            <div class="control-group">
                <label for="elm_staff_first_name" class="control-label cm-required">{__("first_name")}</label>
                <div class="controls">
                    <input type="text" name="staff_data[first_name]" id="elm_staff_first_name" value="{$staff_members.first_name}" size="25" class="input-large" /></div>
            </div>
            <div class="control-group">
                <label for="elm_staff_last_name" class="control-label cm-required">{__("last_name")}</label>
                <div class="controls">
                    <input type="text" name="staff_data[last_name]" id="elm_staff_last_name" value="{$staff_members.last_name}" size="25" class="input-large" /></div>
            </div>
            <div class="control-group">
                <label for="elm_staff_function" class="control-label cm-required">{__("position")}</label>
                <div class="controls">
                    <input type="text" name="staff_data[function]" id="elm_staff_function" value="{$staff_members.function}" size="25" class="input-large" /></div>
            </div>
            <div class="control-group">
                <label for="elm_staff_email" class="control-label cm-required">{__("email")}</label>
                <div class="controls">
                    <input type="text" name="staff_data[email]" id="elm_staff_email" value="{$staff_members.email}" size="25" class="input-large" /></div>
            </div>
            <div class="control-group">
                {hook name="staff_management:detailed_description_label"}
                    <label class="control-label" for="elm_staff_descr">{__("description")}:</label>
                {/hook}
                <div class="controls">
                <textarea id="elm_staff_descr"
                          name="staff_data[description]"
                          cols="55"
                          rows="8"
                          class="cm-wysiwyg input-large"
                          data-ca-is-block-manager-enabled="{fn_check_view_permissions("block_manager.block_selection", "GET")|intval}"
                >{$staff_members.description}</textarea>

                    {if $view_uri}
                        {include
                        file="buttons/button.tpl"
                        but_href="customization.update_mode?type=live_editor&status=enable&frontend_url={$view_uri|urlencode}"
                        but_text=__("edit_content_on_site")
                        but_role="action"
                        but_meta="btn-default btn-live-edit cm-post"
                        but_target="_blank"}
                    {/if}
                </div>
            </div>
            <div class="control-group">
                <label for="elm_staff_position" class="control-label">{__("position_short")}</label>
                <div class="controls">
                    <input type="text" name="staff_data[position]" id="elm_staff_position" value="{$staff_members.position|default:"0"}" size="3"/>
                </div>
            </div>

            {include file="views/localizations/components/select.tpl" data_name="staff_data[localization]" data_from=$staff_members.localization}
        {/hook}
    </div>

    <div id="content_addons" class="hidden clearfix">
        {hook name="staff_management:detailed_content"}
        {/hook}
    <!--content_addons--></div>

    {hook name="staff_management:tabs_content"}
    {/hook}

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

{capture name="buttons"}
    {if !$id}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="staff_members_form" but_name="dispatch[staff_management.update]"}
    {else}
        {if "ULTIMATE"|fn_allowed_for && !$allow_save}
            {assign var="hide_first_button" value=true}
            {assign var="hide_second_button" value=true}
        {/if}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[staff_management.update]" but_role="submit-link" but_target_form="staff_members_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
    {/if}
{/capture}

</form>

{/capture}

{notes}
    {hook name="staff_management:update_notes"}
    {__("staff_members_details_notes", ["[layouts_href]" => fn_url('block_manager.manage')])}
    {/hook}
{/notes}

{if !$id}
    {$title = __("staff_management.new_staff")}
{else}
    {$title_start = __("staff_management.editing_staff")}
    {$title_end = $staff_members.position}
{/if}

{include file="common/mainbox.tpl"
    title_start=$title_start
    title_end=$title_end
    title=$title
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons
    select_languages=true}

{** staff section **}
