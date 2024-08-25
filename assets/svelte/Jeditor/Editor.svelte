<script>
  import { onMount } from "svelte";
  import { activeFile } from "./stores/justboxes";
  import CodeMirror from "svelte-codemirror-editor";
  // import { javascript } from "@codemirror/lang-javascript";
  import { basicSetup } from "codemirror";
  import { EditorView, keymap } from "@codemirror/view";
  import { EditorState } from "@codemirror/state";
  import { vscodeKeymap } from "@replit/codemirror-vscode-keymap";
  import { elixir } from "codemirror-lang-elixir";

  export let value = "";

  const saveKeymap = keymap.of([
    {
      key: "Ctrl-s",
      run: (view) => {
        live.pushEvent("update_file", {
          s3_key: activeFile,
          content: view.state.doc.toString(),
        });
        return true;
      },
      preventDefault: true,
    },
  ]);

  onMount(() => {
    new EditorView({
      state: EditorState.create({
        value,
        extensions: [keymap.of(vscodeKeymap), elixir()],
      }),
      parent: document.querySelector("#editor"),
    });
  });
</script>

<CodeMirror bind:value lang={elixir()} extensions={[saveKeymap]} />
