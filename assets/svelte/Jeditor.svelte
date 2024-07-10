<script>
  import { Pane, Splitpanes } from "svelte-splitpanes";
  import { onMount } from "svelte";
  import {
    Icon,
    DocumentPlus,
    FolderPlus,
    ArrowPath,
    PencilSquare,
    Trash,
  } from "svelte-hero-icons";
  export let s3_keys;
  export let justbox_name;
  export let live;
  export let value;
  import CodeMirror from "svelte-codemirror-editor";
  // import { javascript } from "@codemirror/lang-javascript";
  import { basicSetup } from "codemirror";
  import { EditorView } from "@codemirror/view";
  import { elixir } from "codemirror-lang-elixir";
  import { Wunderbaum } from "wunderbaum";

  let user_handle = "";
  let dirScope = "";

  function refreshExplorer() {
    live.pushEvent("refresh_explorer", {
      handle: user_handle,
      justbox_slug: "test",
    });
  }

  function newFile() {
    live.pushEvent("new_file", {
      handle: user_handle,
      file_s3_key: dirScope + "file",
    });
  }

  function newFolder() {
    live.pushEvent("new_folder", {
      handle: user_handle,
    });
  }

  function setDirScope(path) {
    dirScope = path;
  }

  let treeContainer;

  let treeData = [];

  function createTreeFromPaths(paths) {
    const root = { title: "Root", folder: true, children: [] };

    paths.forEach((path) => {
      const parts = path.split("/");
      let currentNode = root;
      let currentPath = "";

      parts.forEach((part, index) => {
        currentPath += (index === 0 ? "" : "/") + part;
        let existingNode = currentNode.children.find(
          (child) => child.title === part
        );

        if (!existingNode) {
          const newNode = {
            title: part,
            folder: index < parts.length - 1,
            children: [],
            path: currentPath,
          };
          currentNode.children.push(newNode);
          existingNode = newNode;
        }

        currentNode = existingNode;
      });
    });

    return [root];
  }
  function fetchFile(node) {
    live.pushEvent("fetch_file", { s3_key: node.data.path });
  }

  onMount(() => {
    treeData = createTreeFromPaths(s3_keys);
    let currentUrl = window.location.pathname;
    let urlParts = currentUrl.split("/").filter(Boolean);
    user_handle = urlParts[0];
    const tree = new Wunderbaum({
      element: treeContainer,
      source: treeData,
      click: (e) => {
        if (!e.node.data.folder) {
          fetchFile(e.node);
        }
      },
    });
    new EditorView({
      parent: document.querySelector("#editor"),
      extensions: [basicSetup, elixir()],
    });
  });
</script>

<Splitpanes style="height: 50vh; padding: 0.6%;">
  <Pane minSize={5} size={60}>
    <div class="p-2 text-sm rounded-lg border border-blue-400 size-full">
      <Splitpanes style="padding: 0.6%;">
        <Pane minSize={5} size={20}>
          {#if s3_keys === null}
            <div class="text-center">
              <h2 class="text-xl font-medium text-center">Error</h2>
              <p>Failed to fetch files names</p>
            </div>
          {:else}
            <div
              class="pr-2 w-full h-full truncate border-r-2 border-neutral-300"
            >
              <div
                class="flex justify-between p-1 text-sm font-medium text-white bg-blue-500 rounded-t"
              >
                <h2>{justbox_name}</h2>
                <div class="flex items-center space-x-1">
                  <button
                    class="hover:bg-blue-400"
                    title="Refresh explorer"
                    on:click={refreshExplorer}
                  >
                    <Icon src={ArrowPath} size="20" />
                  </button>
                  <button
                    class="hover:bg-blue-400"
                    title="New File"
                    on:click={newFile}
                  >
                    <Icon src={DocumentPlus} size="20" />
                  </button>
                  <button
                    class="hover:bg-blue-400"
                    title="New Folder"
                    on:click={newFolder}
                  >
                    <Icon src={FolderPlus} size="20" />
                  </button>
                </div>
              </div>
              <div bind:this={treeContainer}></div>
            </div>
          {/if}
        </Pane>
        <Pane minSize={5} size={80}>
          <div class="p-1 h-full border-l-2 border-neutral-300">
            {dirScope}
            <CodeMirror bind:value lang={elixir()} />
          </div>
        </Pane>
      </Splitpanes>
    </div>
  </Pane>
  <Pane size={40}>
    <div class="rounded-lg border border-blue-400 size-full">
      <div
        class="px-2 py-1 space-x-2 text-sm font-medium bg-blue-400 rounded-t"
      >
        <button class="px-2 bg-blue-500 rounded text-zinc-200 hover:bg-blue-600"
          >Just Run It
        </button>
        <button class="px-2 bg-blue-500 rounded text-zinc-200 hover:bg-blue-600"
          >Clear
        </button>
      </div>
    </div>
  </Pane>
</Splitpanes>
