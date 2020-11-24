function reLoadPopover() {
  $('[data-toggle="popover"]').popover();
}

$(document).on("playbooks#show:loaded", reLoadPopover);
$(document).on("playbook_pages#show:loaded", reLoadPopover);
