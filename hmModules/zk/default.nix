{
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.zk = {
    enable = true;
    settings = {
      notebook.dir = "~/notebook";
      note = {
        language = "en";
        default-title = "Untitled";
        filename = "{{id}}";
        extension = "md";
        template = "default.md";
      };
      group.journal = {
        paths = [ "journal" ];
        note = {
          filename = "{{format-date now}}";
          template = "journal.md";
        };
      };
      format.markdown = {
        hashtags = false;
        colon-tags = true;
        multiword-tags = false;
      };
      tool = {
        pager = "less -FIRX";
        fzf-preview = "bat --color always {-1}";
      };
      lsp.diagnostics = {
        wiki-title = "hint";
        dead-link = "error";
      };
      lsp.completion = {
        note-label = "{{title-or-path}}";
        note-filter-text = "{{title}} {{path}}";
        note-detail = "{{filename-stem}}";
      };
    };
  };
}
